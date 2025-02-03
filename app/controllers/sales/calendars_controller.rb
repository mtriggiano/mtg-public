class Sales::CalendarsController < ApplicationController
	skip_load_and_authorize_resource
	before_action :set_permission, only: :index
  def index
  	@sales = current_company.sale_files.order("finish_date ASC")
  end

	def set_permission
		authorize! :show, Sales::File
	end
end
