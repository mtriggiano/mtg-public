class Surgeries::ShipmentsController < ApplicationController
  include Attachable
  include Fileable
  include CanAddDetail
  include Indexable
  include ClientFilter
  include Reopen
  include BasicCrud
  include Delivereable
  include Traceable
  expose :shipment, scope: -> {shipments.includes(details: [:product, :batches, childs: [:product, :batches] ])}, model: "Surgeries::Shipment"
  skip_load_and_authorize_resource only: [:get_details, :index]

  def index
    if request.format.json?
      if params[:for_select]
        if collection.respond_to?(:approveds) && params[:from] == "client_bill"
          render json: collection.approveds.map(&:attributes)
        else
          render json: collection.map(&:attributes)
        end
      else
        authorize! :read, obj
        render json: "#{controller_path.classify}Datatable".constantize.new(params, view_context: view_context, collection: collection), status: 200
      end
    else
      authorize! :read, obj
    end
  end

  def get_details
    shipments = current_company.surgery_shipments.where(id: params[:shipment_ids])
    @details = shipments.map(&:details).flatten
  end

  def new_from_bill
    authorize! :create, SaleShipment
    shipment.new_from_bill(params[:surgery_bill_id])
    render :new
  end

  def conform
		authorize! :update, shipment
		shipment.update(conformed_params)
		redirect_to [:edit, shipment]
	end

  def update
    respond_to do |format|
      if shipment.update(shipment_params)
        if params[:request_stock] && !params[:verify_stock]
          current_request, purchase_request = shipment.create_purchase_request
          if current_request.nil? && purchase_request.nil? && params[:request_stock]
            format.html{ redirect_to [:edit, shipment], notice: "Ya existe una solicitud de stock."}
          elsif current_request.nil? && purchase_request.nil? && !params[:request_stock]
            format.html{ redirect_to [:edit, shipment], notice: "Se actualizo existosamente."}
          elsif current_request.nil? && !purchase_request.nil? && params[:request_stock]
            format.html{ redirect_to [:edit, shipment], notice: "Se generó un expediente de compras."}
          elsif !current_request.nil? && purchase_request.nil? && params[:request_stock]
            format.html{ redirect_to [:edit, current_request], notice: "Se genero la solicitud de stock. Por favor complete los datos."}
          elsif !current_request.nil? && !purchase_request.nil? && params[:request_stock]
            format.html{ redirect_to [:edit, current_request], notice: "Se genero la solicitud de stock y un expediente de compra. Por favor complete los datos."}
          end
        elsif params[:verify_stock] && !params[:request_stock]
          shipment.check_stock
          format.html { redirect_to [:edit, shipment], notice: "Stock actualizado, por favor revise."}
        else
          format.html { redirect_to [:edit, shipment], notice: "Documento actualizado."}
        end
      else
        pp shipment.errors
        format.html{ render :edit }
      end
    end
  end

  private

  # TODO: Separar parametros de administrador de los parametros de un usuario comun
  def shipment_params
    params.require(:surgeries_shipment).permit(:store_id, :file_id, :number, :entity_id, :date, :punctuation, :state, :observation, :shipment_type,
      :from, :to, :id_evento, :conformed, :conformed_file,
       location_attributes: [:id, :address, :map, :contact, :phone, :observation],
       details_attributes: [:id, :number, :uniq, :branch, :product_id, :product_name, :product_code, :requested_quantity, :quantity, :observation, :_destroy, :product_measurement, :gtin_id,
        batch_details_attributes: [:id, :batch_id, :quantity, :_destroy],
          childs_attributes: [:id, :number, :product_id, :branch, :product_name, :product_code, :requested_quantity, :quantity, :observation, :_destroy, :product_measurement, :gtin_id,
            batch_details_attributes: [:id, :batch_id, :quantity, :_destroy]]],
       attachments_attributes: %i[id file original_filename _destroy],
       custom_details_attributes: [:id, :tipo, :product_code, :code, :serial, :due_date, :product_measurement, :quantity, :product_name, :_destroy],
       custom_attributes: current_company.surgery_shipment_configs.pluck(:extra_attribute).map { |attribute| attribute.parameterize.underscore.to_sym },
       shipments_sale_orders_attributes: %i[id order_id _destroy])
  end

  def conformed_params
    params.require(:surgeries_shipment).permit(:conformed, :conformed_file)
  end
end
