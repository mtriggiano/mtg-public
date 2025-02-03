class BillMovementsController < ApplicationController
  expose :bill_movements, ->{ BillMovement.joins(bill: :company).where( companies: {id: current_company.id} ) }
  expose :bill_movement, scope: ->{ bill_movements }
  skip_load_and_authorize_resource
  before_action :set_permission
  include BasicCrud
  def index
    if request.format.json?
      render json: BillMovementDatatable.new(params, view_context: view_context, collection: bill_movements), status: 200
    end
  end

  protected
    def bill_movement_params
      params.require(:bill_movement).permit(:date, :bill_id, :delivered_to, :signed, :returned, :observation)
    end

    def set_permission
      authorize! :manage, Sales::Bill
      authorize! :manage, Surgeries::ClientBill
      #authorize! :manage, Tenders::Bill
    end
end
