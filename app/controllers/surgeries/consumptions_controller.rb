class Surgeries::ConsumptionsController < ApplicationController
  expose :consumptions, ->{current_company.surgery_consumptions.includes(details: [:product, batch_details: :batches, childs: [:product, batch_details: :batches]])}
  include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include Reopen
	include BasicCrud
  include Traceable

  expose :consumption, scope: -> {consumptions.includes(details: [:product, :batches, childs: [:product, :batches] ])}, model: "Surgeries::Consumption"
  def new_from_bill
    authorize! :create, SaleShipment
    surgery_consumption.new_from_bill(params[:sale_bill_id])
    render :new
  end

  private

  # TODO: Separar parametros de administrador de los parametros de un usuario comun
  def consumption_params
    params.require(:surgeries_consumption).permit(:total, :store_id, :file_id, :number, :entity_id, :date, :punctuation, :state, :observation, :shipment_type,
      details_attributes: [:id, :number, :total, :price, :uniq, :entity_id, :sended_quantity, :product_id, :product_name, :product_measurement, :product_code, :requested_quantity, :quantity, :observation, :quantity_per_batch, :_destroy, :gtin_id, :iva_aliquot,
        batch_details_attributes: [:id, :batch_id, :quantity, :_destroy],
        childs_attributes: [:id, :number, :total, :price, :product_id, :entity_id, :sended_quantity, :product_name, :product_measurement, :product_code, :requested_quantity, :quantity, :observation, :_destroy, :gtin_id, :iva_aliquot,
          batch_details_attributes: [:id, :batch_id, :quantity, :_destroy]]],
      consumptions_shipments_attributes: %i[id shipment_id _destroy],
      attachments_attributes: %i[id file original_filename _destroy],
      custom_attributes: current_company.surgery_consumption_configs.pluck(:extra_attribute).map { |attribute| attribute.parameterize.underscore.to_sym })
  end
end
