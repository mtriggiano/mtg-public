class Surgeries::SupplierRequestsController < ApplicationController
  include Attachable
  include Fileable
  include CanAddDetail
  include Indexable
  include ClientFilter
  include Reopen
  include BasicCrud

  private

  # TODO: Separar parametros de administrador de los parametros de un usuario comun
  def supplier_request_params
    params
      .require(:surgeries_supplier_request)
      .permit(:file_id, :seller_id, :entity_id, :init_date, :final_date, :urgency, :state, :number, :observation, :request_type, :transport, :pacient, :place, :doctor, :insurance, :shipping, :deliver_to_hospital, :delivery_date,
              details_attributes: [:id, :number, :state, :detail_type, :base_offer, :product_id, :product_supplier_code, :quantity, :approved_quantity, :product_name, :product_measurement, :description, :supplier_price, :_destroy,
                                   childs_attributes: %i[id number state detail_type base_offer product_id product_supplier_code quantity approved_quantity product_name product_measurement description supplier_price _destroy]],
              attachments_attributes: %i[id file original_filename _destroy],
              supplier_requests_purchase_requests_attributes: %i[id purchase_request_id _destroy])
  end
end
