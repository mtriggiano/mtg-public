class Reports::PurchasesController < ApplicationController
  load_and_authorize_resource class: 'Reports::Purchase', except: :index
  skip_load_and_authorize_resource only: :index

  def index
    authorize! :access, :reports

    case params[:view]
    when 'payment_orders'
      if request.format.json?
        col = Purchases::PaymentOrder.where(state: ['Aprobado', 'Confirmado', 'Anulado'])
        render json: Reports::PaymentOrderDatatable.new(params, view_context: view_context, collection: col), status: 200
      end
    when 'costing'
      if request.format.json?
        col = Reports::Costing.all
        render json: Reports::CostingDatatable.new(params, view_context: view_context, collection: col), status: 200
      end
    else
      if request.format.json?
        col = ExternalBill.where(state: ['Aprobado', 'Confirmado', 'Anulado'])
        render json: Reports::PurchaseDatatable.new(params, view_context: view_context, collection: col), status: 200
      end
    end
  end

  def costing
    @file = Reports::Costing.find(params[:id])
    authorize! :read, @file
  end
end
