class Sales::BudgetsController < ApplicationController
	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include ShowPdf
	include Reopen
	include BasicCrud
	include Delivereable

	# def deliver
	# 	Sales::BudgetMailer.send_to_client(budget, params[:email]).deliver
	# 	redirect_to edit_sales_budget_path(budget.id), notice: "El comprobante fue enviado con éxito"
	# end

  	private
  		#TODO Separar parametros de administrador de los parametros de un usuario comun
  		def budget_params
  			params.require(:sales_budget).permit(:number, :payment_type, :budget_state, :entity_id, :seller_id, :entity_contact_id, :delivery_date, :delivery_address, :init_date, :final_date, :discount, :total, :usd_price, :total_usd, :state, :observation, :file_id, :currency, :subtotal,
  				details_attributes: [:id, :number, :detail_type, :base_offer, :state, :product_id, :description, :product_name, :quantity, :product_code, :product_measurement, :price, :discount, :iva_aliquot, :iva_amount, :total, :observation, :_destroy,
						childs_attributes: [:id, :number, :detail_type, :base_offer, :state, :product_id, :description, :product_name, :quantity, :product_code, :product_measurement, :price, :discount, :total, :observation, :_destroy],
					],
      			attachments_attributes: [:id, :file, :original_filename, :_destroy],
  				budgets_sale_requests_attributes: [:id, :request_id, :_destroy],
      			custom_attributes: current_company.sale_budget_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
  			)
  		end
end
