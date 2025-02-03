class Employees::UsersController < ApplicationController
  	expose :users, -> {current_company.users}
  	expose :user, scope: -> {users}
    include Alertable

    def become
        #return unless current_user.is_an_admin?
        sign_in(:user, User.find(params[:user_id]))
        redirect_to root_url # or user_root_url
    end
end
