class Reports::SellIvaMovementsController < ApplicationController
	load_and_authorize_resource class: 'Reports::SellIvaMovement', except: :index
	skip_load_and_authorize_resource only: :index
  
	expose :sell_iva_movements, -> { current_company.expedient_bills.where(flow: 'income', state: ['Aprobado', 'Confirmado', 'Anulado']) }
  
	def index
	  authorize! :access, :reports
  
	  if request.format.json?
		render json: Reports::SellIvaMovementDatatable.new(params, view_context: view_context, collection: sell_iva_movements), status: 200
	  end
	end
  
	def export
	  authorize! :export, :sell_iva_movements
  
	  @bills = BillManager::Importer.new(company: current_company).export
	  respond_to do |format|
		format.xlsx {
		  render xlsx: "export.xlsx.axlsx", disposition: "attachment", filename: "reporte_iva_ventas.xlsx"
		}
	  end
	end
  end
  