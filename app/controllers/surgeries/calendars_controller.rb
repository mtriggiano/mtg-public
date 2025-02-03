class Surgeries::CalendarsController < ApplicationController
	skip_load_and_authorize_resource
	before_action :set_permission, only: :index
  def index
  	@surgeries = current_company.surgery_files.order("finish_date ASC")
  end

	def set_permission
		authorize! :show, Surgeries::File
	end
end
