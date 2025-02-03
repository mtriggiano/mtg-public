class Stores::Externals::StoreLinesController < ApplicationController

  	expose :external_store, scope: ->{ current_company.external_stores}, id: ->{ params[:external_id] }
  	expose :store_lines, ->{ external_store.lines}
  	expose :store_line, scope: ->{ external_store.lines}
  	skip_load_and_authorize_resource

	def index
		respond_to do |format|
			format.html
			format.js
			format.json { render json: StoreLineDatatable.new(params, view_context: view_context, external_store: external_store), status: 200 }
		end
    end

	def show
	end

	def new
	end

	def edit
	end

	def create
		store_line.store_id = external_store.id
    	respond_to do |format|
    		if store_line.save
    			format.html {redirect_to stores_external_path(external_store.id), notice: "Especialidad creada con éxito"}
    		else
    			pp store_line.errors
    			format.html {render :edit}
    		end
    	end
    end

    def update
    	respond_to do |format|
    		if store_line.update(store_line_params)
    			format.html {redirect_to stores_external_path(external_store.id), notice: "Epecialidad creada con éxito"}
    		else
    			format.html {render :edit}
    		end
    	end
    end

    def destroy
    	respond_to do |format|
    		if store_line.destroy
    			format.html {redirect_to stores_external_path(external_store.id), notice: "Epecialidad eliminada con éxito"}
    		else
    			format.html {render :index}
    		end
    	end
    end

    private
    	def store_line_params
    		params.require(:store_line).permit(:name)
    	end

end
