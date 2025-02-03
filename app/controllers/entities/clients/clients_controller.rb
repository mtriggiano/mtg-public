class Entities::Clients::ClientsController < ApplicationController
	skip_load_and_authorize_resource only: :index_by
	expose :clients, -> { current_company.clients.search(params[:q]) }
	expose :client, scope: ->{ clients }
  	include Indexable
  	before_action :set_current_user, only: [:create, :update]

	skip_load_and_authorize_resource only: [:index_by]



	def show
	end

	def new
	end

	def edit
	end

	def create
		respond_to do |format|
			client.locality_id = Locality.set_locality(params[:client][:locality_id], params[:client][:province_id])
			if client.save
				format.html { redirect_to client, notice: "Cliente creado con éxito" }
			else
				format.html { render :new }
				pp client.errors
			end
		end
	end

	def update
		respond_to do |format|
			params[:client][:locality_id] = Locality.set_locality(params[:client][:locality_id], params[:client][:province_id])
			if client.update(client_params)
				format.html { redirect_to client, notice: "Cliente actualizado con éxito" }
			else
				pp client.errors
				format.html { render :edit }
			end
		end
	end

	def destroy
		respond_to do |format|
			if client.destroy
				format.html { redirect_to clients, notice: "Cliente eliminado con éxito" }
			else
				format.html { render :index }
			end
		end
	end

  	def index_by
    	render json: clients.where("LOWER(entities.name) ILIKE LOWER(?)", "%#{params[:q]}%").map{|sc| {id: sc.id, text: sc.name, current_debt: sc.current_debt}}
  	end

		def import
			ClientManager::Importer.import_exel(params[:file], current_user)
			respond_to do |format|
		      	format.html { redirect_to clients_path, notice: 'Proveedores cargados' }
		    end
		end

		def debt
			bills = client.bills.approveds.where("total_left > 0")
			respond_to do |format|
				format.html
				format.json{ render json: Entities::Clients::DebtDatatable.new(params, view_context: view_context, collection: bills), status: 200 }
			end
		end

	private

	def client_params
		params.require(:client).permit(:name, :subtype, :parent_id, :gln, :client_type, :address, :document_type, :document_number, :iva_cond, :recharge, :denomination, :payment_type_id, :payment_days, :province_id, :locality_id, :cp, :iibb_aliquot, :iibb_perception, :id_medtronic)
	end

	def set_current_user
	    client.extend(Virtus.model)
	    client.attribute :user, User
	    client.user = current_user
	end

	def locality_select
		client.locality_id = Locality.set_locality(params[:client][:locality_id], params[:client][:province_id])
	end
end
