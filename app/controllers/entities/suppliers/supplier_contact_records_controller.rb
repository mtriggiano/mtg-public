class Entities::Suppliers::SupplierContactRecordsController < ApplicationController
	skip_load_and_authorize_resource
	expose :supplier, parent: :current_company
	expose :contact, id: :supplier_contact_id, model: SupplierContact, scope: ->{supplier.contacts}
	expose :supplier_contact_records, ->{ contact.records}
	expose :supplier_contact_record, scope: ->{supplier_contact_records}
	before_action :set_permission
	
	include Indexable

	def show; end

	def new; end

	def edit; end

	def create
		supplier_contact_record.user_id = current_user.id
		if supplier_contact_record.save
			redirect_to supplier_supplier_contact_path(supplier, contact, view: 'contact_records'), notice: "Registro creado con éxito"
		else
			render :edit
		end
	end

	def update
		supplier_contact_record.user_id = current_user.id
		if supplier_contact_record.update(supplier_contact_record_params)
			redirect_to supplier_supplier_contact_path(supplier, contact, view: 'contact_records'), notice: "Actualizacion exitosa"
		else
			render :edit
		end
	end

	def destroy
		supplier_contact_record.destroy
		redirect_to supplier_supplier_contact_path(supplier, contact, view: 'contact_records'), notice: "Se eliminó el registro con éxito"
	end

	private
		def set_permission
			authorize!(:manage, Supplier) 
			authorize!(:read, Supplier) 
			authorize!(:show, Supplier)
		end

		def supplier_contact_record_params
			params.require(:supplier_contact_record).permit(:title, :date, :object, :body)
		end
end
