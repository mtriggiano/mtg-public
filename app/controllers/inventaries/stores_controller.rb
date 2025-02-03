class Inventaries::StoresController < ApplicationController
  expose :stores, ->{ current_company.stores}
	expose :store, scope: ->{ stores }

	include Indexable
	include BasicCrud

  	def products
    	render json: Inventaries::StoreProductDatatable.new(params, view_context: view_context, collection: store), status: 200
  	end

    def create
      store.company_id = current_company.id
  		if store.save
  			redirect_to stores_url
  		else
  			render :new
  		end
  	end

    def update
      store.company_id = current_company.id
  		if store.update(store_params)
  			redirect_to stores_url
  		else
  			render :edit
  		end
  	end

    private

    def store_params
			#TODO
			params.require(:store).permit(:company_id, :name, :location)
		end
end
