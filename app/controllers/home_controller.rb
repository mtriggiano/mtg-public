class HomeController < ApplicationController
	skip_before_action  :authenticate_user!
	skip_load_and_authorize_resource

	def index
	end

	def forbidden
		action = params[:current_action] == "new" ? "create" : params[:current_action]
		action = params[:current_action] == "edit" ? "update" : action
		# @ability = RoleAbility.find_by(class_name: params[:subject].to_s).ability_actions.find_by(name: action.to_s)
	end
end
