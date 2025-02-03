class FileAttributesConfigsController < ApplicationController
	skip_load_and_authorize_resource
  	def new
  	end

  	def edit
  	end

  	def update
	  	respond_to do |format|
	  		if current_company.update(file_attributes_config_params)
	  			format.html { redirect_to request.referer, notice: "Campos actualizados con éxito"}
	  		else
	  			format.html {render :new}
	  		end
	  	end
  	end

  	def create
	  	respond_to do |format|
	  		if current_company.save(file_attributes_config_params)
	  			format.html { redirect_to request.referer, notice: "Campos actualizados con éxito"}
	  		else
	  			format.html {render :new}
	  		end
	  	end
  	end

  	private

  	def file_attributes_config_params
  		params.require(:company).permit(file_attributes_config_attributes: [:id, :extra_attribute, :parent_model, :quantity, :_destroy])
  	end
end
