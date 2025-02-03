module Reopen
	extend ActiveSupport::Concern

	included do
		alias_method :document, "#{controller_name.snakecase.singularize}".to_sym
	end

	def open
		set_s3_direct_post
		response = ::ReopenerService.new(document, current_user).open
		respond_to do |format|
			if response[:result]
				if response[:opened]
					format.html {redirect_to [:edit, document], notice: response[:message]}
				else
					format.html {render :edit, alert: response[:message]}
				end
			else
				format.html {render :edit, alert: "Algo salio mal."}
			end
		end
	end
end
