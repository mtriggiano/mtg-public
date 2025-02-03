class Entities::Suppliers::SuppliersController < ApplicationController
	expose :suppliers, ->	{ current_company.suppliers.includes(:contacts).search(params[:q]).order("entities.created_at") }
	expose :supplier, scope: ->{ suppliers }
	load_and_authorize_resource except: :index_by_company
	include Indexable

	skip_load_and_authorize_resource only: [:index_by_company]

	def create
		supplier.user = current_user
		if supplier.save
			redirect_to supplier, notice: "Proveedor creado con éxito"
		else
			render :new
		end
	end

	def import
		SupplierManager::Importer.import_exel(params[:file], current_user)
		respond_to do |format|
	      	format.html { redirect_to suppliers_path, notice: 'Proveedores cargados' }
	    end
	end

	def update
		supplier.user = current_user
		if supplier.update(supplier_params)
			redirect_to supplier, notice: "Actualizacion exitosa"
		else
			render :edit
		end
	end

	def destroy
		if supplier.destroy
			redirect_to suppliers_path, notice: "Se eliminó el registro con éxito"
		else
			render :show
		end
	end

	def index_by_company
		render json: suppliers.search(params[:q]).map{|supplier| {id: supplier.id, text: supplier.name}}
	end

	private
		def supplier_params
			params.require(:supplier).permit(:name, :gln, :document_type, :document_number, :address, :cbu, :account, :bank, :iva_cond, :sector)
		end
end
