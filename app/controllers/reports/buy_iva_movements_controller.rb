class Reports::BuyIvaMovementsController < ApplicationController
    expose :buy_iva_movements, ->{ current_company.external_bills.where(state: ['Aprobado', 'Confirmado', 'Anulado']) }
    skip_load_and_authorize_resource
    def index
        if request.format.json?
            render json: Reports::BuyIvaMovementDatatable.new(params, view_context: view_context, collection: BuyIvaMovement.collection), status: 200
        end
    end
end