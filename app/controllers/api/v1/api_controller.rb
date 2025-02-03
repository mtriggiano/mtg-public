
    class Api::V1::ApiController < ActionController::Base
      #include ExceptionLogger::ExceptionLoggable # loades the module
      #rescue_from Exception, with: :log_exception_handler # tells rails to forward the 'Exception' (you can change the type) to the handler of the module

      protected

      def authenticate
        authenticate_token || render_unauthorized
      end

      def authenticate_the_user
        authentication_token_user || render_unauthorized
      end

      def authenticate_token
        authenticate_with_http_token do |token, options|
          User.exists?(authentication_token: token)
          ## User.find_by(authentication_token: token)
        end
      end

      def authentication_token_user
        authenticate_with_http_token do |token, options|
          @the_user = User.find_by(authentication_token: token)
        end
      end

      def render_unauthorized
        headers["WWW-Authenticate"] = 'Token realm="Application"'
        render json: {messages: "Token inválido"}, status: 401
      end
    end
