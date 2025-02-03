class Entities::Clients::ClientContactsController < ApplicationController
	skip_load_and_authorize_resource
	expose :client, scope: ->{current_company.clients}, id: ->{params[:client_id] || params[:extra_data]}
	expose :client_contacts, ->{client.contacts.search_by(:name, params[:q])}
	expose :client_contact, scope: -> {client_contacts}
	before_action :set_permission
	include Indexable

	def show; end

	def new; end

	def edit; end

	def create
		if client_contact.save
			redirect_to [client, client_contact], notice: "Contact creado con éxito"
		else
			pp client_contact.errors
			render :new
		end
	end

	def update
		if client_contact.update(client_contact_params)
			redirect_to [client, client_contact], notice: "Actualizacion exitosa"
		else
			render :edit
		end
	end

	def destroy
		if client_contact.destroy
			redirect_to client_client_contacts_path(client), notice: "Se eliminó el registro con éxito"
		else
			render :show
		end
	end

	def index_by_client
		authorize! :read, ClientContact
		render json: client_contacts.where("LOWER(client_contacts.name) ILIKE LOWER(?)", "%#{params[:term] || params[:extra_data]}%").map{|sc| {id: sc.id, text: sc.name}}
	end

	private

		def set_permission
			authorize!(:manage, Client) 
			authorize!(:read, Client) 
			authorize!(:show, Client)
		end

		def client_contact_params
			params.require(:client_contact).permit(:name, :position, :email, :phone, :mobile_phone, :titular)
		end
end
