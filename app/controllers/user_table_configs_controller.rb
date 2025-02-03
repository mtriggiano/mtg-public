class UserTableConfigsController < ApplicationController

	def create
		if params[:_destroy]
		 	current_user.table_configs.find_by(table: params[:table]).hidden_attributes.where(col: params[:attribute]).first.destroy
		else
			table_config = current_user.table_configs.where(table: params[:table]).first_or_initialize
			table_config.hidden_attributes.where(col: params[:attribute]).first_or_initialize
			table_config.save
		end
	end
end
