class Reports::ShipmentsController < ApplicationController
  load_and_authorize_resource class: 'Reports::Shipment', except: :index
  skip_load_and_authorize_resource only: :index

  def index
    authorize! :access, :reports

    @shipments = current_company.expedient_shipments
    @sellers = User.where(id: ExpedientOrderDetail.pluck(:user_id).uniq)

    filtered
    respond_to do |format|
      format.html
      format.json { render json: Reports::ShipmentInvoiceDatatable.new(params, view_context: view_context, collection: @shipments) }
    end
  end

  private

  def filtered
    return unless params[:filtros].present?

    if filtro_params[:tipo].present?
      case filtro_params[:tipo]
      when "Cirujia"
        @shipments = @shipments.where(type: "Surgeries::Shipment")
      when "Venta"
        @shipments = @shipments.where(type: "Sales::Shipment")
      end
    end

    case filtro_params[:sin_facturas]
    when "Sin facturas asociadas"
      @shipments = @shipments.sin_facturas
    when 'Con facturas asociadas'
      @shipments = @shipments.con_facturas
    end

    if filtro_params[:seller_id].present?
      @shipments = @shipments.includes(file: { expedient_orders: { all_details: :seller } })
                             .where(users: { id: filtro_params[:seller_id] })
    end

    @shipments = @shipments.fecha_start(filtro_params[:fecha_start]) if filtro_params[:fecha_start].present?
    @shipments = @shipments.fecha_end(filtro_params[:fecha_end]) if filtro_params[:fecha_end].present?
  end

  def filtro_params
    params.require(:filtros).permit(
      :tipo,
      :sin_facturas,
      :seller_id,
      :fecha_start,
      :fecha_end
    )
  end
end
