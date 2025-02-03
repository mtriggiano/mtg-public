class Stores::ExternalsController < ApplicationController
    skip_load_and_authorize_resource
    before_action { raise CanCan::AccessDenied unless Ability.new(current_user).can?(params[:action].to_sym, ExternalStore) }
  	expose :external_stores, ->{ current_company.external_stores}
  	expose :external_store, scope: ->{ current_company.external_stores}

  	def index
  		respond_to do |format|
  			format.html
  			format.js
  			format.json { render json: ExternalStoreDatatable.new(params, view_context: view_context, company: current_company), status: 200 }
  		end
  	end

    def show
    end

    def new
    end

    def edit
    end

    def create
    	respond_to do |format|
    		if external_store.save
    			format.html {redirect_to stores_externals_path, notice: "Banco creado con éxito"}
    		else
    			format.hmtl {render :edit}
    		end
    	end
    end

    def update
    	respond_to do |format|
    		if external_store.update(external_store_params)
    			format.html {redirect_to stores_externals_path, notice: "Banco creado con éxito"}
    		else
    			format.hmtl {render :edit}
    		end
    	end
    end

    def destroy
    	respond_to do |format|
    		if external_store.destroy
    			format.html {redirect_to stores_externals_path, notice: "Banco eliminado con éxito"}
    		else
    			format.hmtl {render :index}
    		end
    	end
    end

    def available_store_lines
      render json: external_store.lines.map{|l| {id: l.id, text: l.name}}
    end

    private
    	def external_store_params
    		params.require(:external_store).permit(:name, :location)
    	end
end
