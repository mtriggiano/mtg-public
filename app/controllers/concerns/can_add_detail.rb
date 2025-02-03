module CanAddDetail
	extend ActiveSupport::Concern

	included do
		helper_method :record
		skip_load_and_authorize_resource only: :add_detail
	end

	def add_detail
		@detail 	= record.details.where(id: params[:detail_id]).first_or_initialize
		@index 		= params[:index]
		inventary 	= current_company.inventaries.find(params[:product_id])
		@recharge 	= set_recharge
		record.add_detail(inventary, @detail, params[:supplier_id], params[:page]) unless params[:without_childs] == "true"
		render template: "/layouts/add_detail.js.erb"
	end

	def assign_details
		unless params[:documents].blank?
  			record.assign_details(params, params[:number]) 
  		end
	end

	private
		def record
			eval(controller_name.singularize)
		end

		def set_recharge
			if params[:client_id].blank?
				return 0.0
			else
				current_company.clients.find(params[:client_id]).recharge
			end
		end
end
