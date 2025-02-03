class Reports::SuppliersController < ApplicationController
  load_and_authorize_resource class: 'Reports::Supplier', except: [:index]
  skip_load_and_authorize_resource only: [:index]

  def index
    authorize! :access, :reports

    if request.format.json?
      col = PaymentOrder.approveds
      render json: Reports::PaymentOrderDatatable.new(params, view_context: view_context, collection: col), status: 200
    end
  end
end
