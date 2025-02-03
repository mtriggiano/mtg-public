class Tenders::BudgetsController < ApplicationController
	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include Reopen
	include BasicCrud
	include Delivereable

	# def deliver
	# 	Tenders::TenderBudgetMailer.send_to_client(tender_budget, params[:email]).deliver_later
	# 	redirect_to edit_tender_budget_path(tender_budget.id), notice: "El comprobante fue enviado con éxito"
	# end

  	private
  		#TODO Separar parametros de administrador de los parametros de un usuario comun
  		def budget_params
  			params.require(:tenders_budget).permit(:number, :payment_type, :seller_id, :entity_id, :entity_contact_id, :delivery_date, :delivery_address, :init_date, :final_date, :discount, :total, :state, :observation, :file_id, :total_usd, :usd_price, :currency,
  				details_attributes: [:id, :detail_type, :base_offer, :description, :state, :product_id, :product_name, :quantity, :product_code, :product_measurement, :price, :discount, :iva_aliquot, :iva_amount, :total, :observation, :_destroy,
						childs_attributes: [:id, :detail_type, :base_offer, :state, :product_id, :product_name, :quantity, :product_code, :product_measurement, :price, :discount, :total, :observation, :_destroy],
					],
      			attachments_attributes: [:id, :file, :original_filename, :_destroy],
      			custom_attributes: current_company.tender_budget_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym}
  			)
  		end
end
