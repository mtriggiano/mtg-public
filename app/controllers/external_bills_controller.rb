class ExternalBillsController < ApplicationController
	include Indexable
	include BasicCrud
	include Fileable
	include CanAddDetail
	include Reopen

	def index
		if params[:file_id]
			render json: ExternalBillDatatable.new(params, view_context: view_context, collection: current_company.expedients.find(params[:file_id]).supplier_bills), status: 200
		else
			super
		end
	end

	def new
    	super
    	external_bill.entity_id = params[:entity_id] if params[:entity_id]
  	end

  	def edit
	    super
	    external_bill.entity_id = params[:entity_id] if params[:entity_id]
  	end

  	def associate_document
    	external_bill.associate(params[:bill])
    	render :new
  	end

  	private

	  	def external_bill_params
	    	params.require(:external_bill).permit(:purchase_arrival_id, :entity_id, :cbte_tipo, :sale_point, :number, :cbte_fch, :registration_date, :due_date, :file_id, :user_id, :total_trib, :total, :usd_price, :total_usd, :iva_amount, :company_id, :state, :attachment, :observation, :concept, :fch_ser_desde, :fech_ser_hasta, :fch_vto_pago, :gross_amount, :currency,
  				details_attributes: [:id, :product_id, :product_name, :product_code, :quantity, :price, :iva_aliquot, :discount, :product_measurement, :iva_amount, :subtype, :total, :_destroy],
  				attachments_attributes: [:id, :file, :original_filename, :_destroy],
  				external_bills_expedient_orders_attributes: [:id, :order_id, :_destroy],
  				external_bills_external_arrivals_attributes: [:id, :arrival_id, :_destroy],
  				tributes_attributes: [:id, :afip_id, :base_imp, :alic, :amount,  :description, :_destroy]
	    	)
	  	end
end
