class Entities::Suppliers::SupplierContactsController < ApplicationController
	before_action :set_s3_direct_post, only: [:new, :edit, :show, :create, :update]
	skip_load_and_authorize_resource
	before_action :set_permission
	expose :supplier, scope: ->{current_company.suppliers}
	expose :supplier_contacts, ->{supplier.contacts}
	expose :supplier_contact, scope: -> {supplier_contacts}
	include Indexable

	def new; end

	def edit; end

	def show
	  # code
	end

	def create
		# set_company
		if supplier_contact.save
			redirect_to [supplier, supplier_contact], notice: "Contact creado con éxito"
		else
			render :new
		end
	end

	def update
		# set_company
		if supplier_contact.update(supplier_contact_params)
			redirect_to [supplier, supplier_contact], notice: "Actualizacion exitosa"
		else
			render :edit
		end
	end

	def destroy
		if supplier_contact.destroy
			redirect_to supplier_supplier_contacts_path(supplier), notice: "Se eliminó el registro con éxito"
		else
			render :show
		end
	end

	def index_by_supplier
		authorize! :read, SupplierContact
		supplier = current_company.suppliers.find(params[:extra_data])
		render json: supplier.contacts.search(params[:q]).map{|sc| {id: sc.id, text: sc.name}}
	end

	private

		def set_permission
			authorize!(:manage, Supplier) 
			authorize!(:read, Supplier) 
			authorize!(:show, Supplier)
		end

		def set_company
			supplier_contact.company_id = current_company.id
		end

		def supplier_contact_params
			params.require(:supplier_contact).permit(:name, :avatar, :position, :email, :phone, :mobile_phone, :titular)
		end
end
