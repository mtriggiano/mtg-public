class Surgeries::BudgetsController < ApplicationController
 	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include Reopen
	include BasicCrud
  include Delivereable
	# def deliver
	# 	Sales::BudgetMailer.send_to_client(budget, params[:email]).deliver
	# 	redirect_to edit_surgeries_budget_path(budget.id), notice: "El comprobante fue enviado con éxito"
	# end

  	private
	#TODO Separar parametros de administrador de los parametros de un usuario comun
	def budget_params
		params.require(:surgeries_budget).permit(:number, :payment_type, :budget_state, :seller_id, :entity_id, :entity_contact_id, :entity_contact_id, :delivery_date, :delivery_address, :init_date, :final_date, :discount, :total, :total_usd, :usd_price, :state, :observation, :file_id, :currency, :subtotal,
			details_attributes: [:id, :branch, :source, :iva_amount, :detail_type, :base_offer, :state, :product_id, :product_name, :quantity, :product_code, :product_supplier_code, :product_measurement, :price, :discount, :iva_aliquot, :total, :description, :_destroy,
					childs_attributes: [:id, :branch, :source, :iva_amount, :detail_type, :base_offer, :state, :product_id, :product_name, :quantity, :product_code, :product_measurement, :price, :product_supplier_code, :discount, :total, :description, :_destroy],
				],
			attachments_attributes: [:id, :file, :original_filename, :_destroy],
			budgets_prescriptions_attributes: [:id, :request_id, :_destroy],
			custom_attributes: current_company.surgery_budget_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
		)
	end
end
