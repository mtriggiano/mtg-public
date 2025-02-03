class Users::InvitationsController < Devise::InvitationsController

	def invite_resource
      super { |user| user.company_id = current_user.company_id }
    end

    def after_invite_path_for(resource)
    	company_path(current_company, view: "users")
  	end
end