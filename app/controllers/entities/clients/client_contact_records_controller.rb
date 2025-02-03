class Entities::Clients::ClientContactRecordsController < ApplicationController
	expose :client, parent: :current_company
	expose :contact, id: :client_contact_id, model: ClientContact, scope: ->{client.contacts}

	expose :client_contact_records, ->{ contact.records}
	expose :client_contact_record, scope: ->{client_contact_records}
	skip_load_and_authorize_resource
  	before_action :set_permission
	include Indexable

	def show; end

	def new; end

	def edit; end

	def create
		client_contact_record.user_id = current_user.id
		if client_contact_record.save
			redirect_to client_client_contact_path(client, contact, view: 'contact_records'), notice: "Registro creado con éxito"
		else
			render :edit
		end
	end

	def update
		client_contact_record.user_id = current_user.id
		if client_contact_record.update(client_contact_record_params)
			redirect_to client_client_contact_path(client, contact, view: 'contact_records'), notice: "Actualizacion exitosa"
		else
			render :edit
		end
	end

	def destroy
		client_contact_record.destroy
		redirect_to client_client_contact_path(client, contact, view: 'contact_records'), notice: "Se eliminó el registro con éxito"
	end

	private
		def set_permission
	    authorize!(:manage, Client)
	    authorize!(:read, Client)
	    authorize!(:show, Client)
		end

		def client_contact_record_params
			params.require(:client_contact_record).permit(:title, :date, :object, :body)
		end
end
