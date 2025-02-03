class Reports::ClientsController < ApplicationController
	load_and_authorize_resource class: 'Reports::Client', except: :index
	skip_load_and_authorize_resource only: :index
  
	expose :clients, -> { current_company.clients }
	expose :client, scope: -> { current_company.clients }
  
	def index
	  authorize! :access, :reports
  
	  if request.format.json?
		render json: Reports::ClientDatatable.new(params, view_context: view_context, collection: clients), status: 200
	  end
	end
  
	def show
	  authorize! :read, :clients
  
	  render pdf: "#{client.name}",
			 layout: 'pdf.html',
			 viewport_size: '1280x1024',
			 page_size: 'A4',
			 disposition: 'inline',
			 orientation: 'landscape',
			 encoding: "UTF-8"
	end
  end
  