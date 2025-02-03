class Reports::StoragesController < ApplicationController
	load_and_authorize_resource class: 'Reports::Storage', except: [:index, :for_calendar, :export_arrival_products, :export_batches]
	skip_load_and_authorize_resource only: [:index, :for_calendar, :export_arrival_products, :export_batches]
	layout false, only: :for_calendar
  
	def index
	  authorize! :access, :reports
  
	  case params[:view]
	  when "calendar_table"
		if request.format.json?
		  render json: Reports::CalendarDatatable.new(params, view_context: view_context, collection: Expedient.where.not(type: "Purchases::File")), status: 200
		end
	  when "shipments"
		if request.format.json?
		  @col = current_company.expedient_shipments.search_in_report(params[:bills_band]).search_by_client(params[:client_id])
		  render json: Reports::ShipmentDatatable.new(params, view_context: view_context, collection: @col), status: 200
		end
	  when "arrivals"
		if request.format.json?
		  col = current_company.external_arrivals.where(state: ["Aprobado", "Confirmado", "Anulado"])
		  render json: Reports::ArrivalDatatable.new(params, view_context: view_context, collection: col), status: 200
		end
	  when "consumptions"
		if request.format.json?
		  col = current_company.surgery_consumptions.where(state: ["Aprobado", "Confirmado", "Anulado"])
		  render json: Reports::ConsumptionDatatable.new(params, view_context: view_context, collection: col), status: 200
		end
	  when "table_calendar"
		if request.format.json?
		  col = current_company.expedients
				.where(type: ["Sales::File", "Surgeries::File", "Tenders::File"])
				.order("files.delivery_date ASC")
		  @files = col
		  render json: Reports::FileDatatable.new(params, view_context: view_context, collection: col), status: 200
		end
	  else
		@files = current_company.expedients
				 .where(type: ["Sales::File", "Surgeries::File", "Tenders::File"])
				 .order("files.delivery_date ASC")
	  end
	end
  
	def for_calendar
	  authorize! :access, :reports
  
	  @files = current_company.expedients
			  .where(type: ["Sales::File", "Surgeries::File", "Tenders::File"])
			  .where(delivery_date: params[:date])
			  .order("files.delivery_date ASC")
	end
  
	def export_arrival_products
	  authorize! :access, :reports
  
	  @batch_details = BatchDetail.find(params[:batch_details])
	  respond_to do |format|
		format.xlsx {
		  render xlsx: "export_arrival_products.xlsx.axlsx", disposition: "attachment", filename: "Reporte-EntradasxProd.xlsx"
		}
	  end
	end
  
	def export_batches
	  authorize! :access, :reports
  
	  @batches = Batch.where(id: params[:batches], state: true)
	  respond_to do |format|
		format.xlsx {
		  render xlsx: "export_batches.xlsx.axlsx", disposition: "attachment", filename: "Reporte-Lotes.xlsx"
		}
	  end
	end
  end
  