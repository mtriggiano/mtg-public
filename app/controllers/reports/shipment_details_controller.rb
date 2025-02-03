class Reports::ShipmentDetailsController < ApplicationController
  load_and_authorize_resource class: 'Reports::ShipmentDetail', except: [:index]
  skip_load_and_authorize_resource only: [:index]

  def index
    authorize! :access, :reports

    @shipment_details = current_company.expedient_shipment_details
    filtered

    respond_to do |format|
      format.html {
        @sellers = User.where(id: ExpedientOrderDetail.pluck(:user_id).uniq)
        @suppliers = Supplier.where(id: @shipment_details.includes(:product).pluck("products.supplier_id").uniq)
        @client_medtronic_ids = @shipment_details.includes(shipment: :client).pluck("entities.id_medtronic").uniq.reject(&:blank?)
      }
      format.json { render json: Reports::ShipmentDetailDatatable.new(params, view_context: view_context, collection: @shipment_details) }
    end
  end

  private

  def filtered
    return unless params[:filtros].present?

    case filtro_params[:tipo]
    when "Cirujia"
      @shipment_details = @shipment_details.where(type: "Surgeries::ShipmentDetail")
    when "Venta"
      @shipment_details = @shipment_details.includes(:shipment).where(type: "Sales::ShipmentDetail")
    end

    case filtro_params[:sin_facturas]
    when 'Con facturas asociadas'
      @shipment_details = @shipment_details.con_facturas
    when "Sin facturas asociadas"
      @shipment_details = @shipment_details.sin_facturas
    end

    if filtro_params[:id_medtronic].present?
      @shipment_details = @shipment_details.includes(shipment: :client).where("entities.id_medtronic = ?", filtro_params[:id_medtronic]).references(:clients)
    end

    if filtro_params[:seller_id].present?
      @shipment_details = @shipment_details.where(users: { id: filtro_params[:seller_id] })
    end

    if filtro_params[:supplier_id].present?
      @shipment_details = @shipment_details.includes(:product).where(products: { supplier_id: filtro_params[:supplier_id] })
    end

    @shipment_details = @shipment_details.includes(:shipment).where("shipments.date >= ?", filtro_params[:fecha_desde].to_date) if filtro_params[:fecha_desde].present?
    @shipment_details = @shipment_details.includes(:shipment).where("shipments.date <= ?", filtro_params[:fecha_hasta].to_date) if filtro_params[:fecha_hasta].present?
    @shipment_details = @shipment_details.joins(shipment: :expedient_bills).where("bills.date >= ?", filtro_params[:fecha_factura_desde].to_date) if filtro_params[:fecha_factura_desde].present?
    @shipment_details = @shipment_details.joins(shipment: :expedient_bills).where("bills.date <= ?", filtro_params[:fecha_factura_hasta].to_date) if filtro_params[:fecha_factura_hasta].present?
  end

  def filtro_params
    params.require(:filtros).permit(
      :tipo,
      :sin_facturas,
      :id_medtronic,
      :seller_id,
      :supplier_id,
      :fecha_desde,
      :fecha_hasta,
      :fecha_factura_desde,
      :fecha_factura_hasta
    )
  end
end
