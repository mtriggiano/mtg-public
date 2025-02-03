class Inventaries::BatchesController < ApplicationController
	expose :product, scope: ->{ current_company.products }
	expose :batches, ->{ product.batches }
	expose :batch, scope: ->{ batches }
	include Indexable

	skip_load_and_authorize_resource only: [:unit_gtins, :availables]

	def show
		authorize! :read, Batch
		respond_to do |format|
			format.json{ render json: batch.to_json}
			format.html
		end
	end

	def unit_gtins
		render json: batch.gtins.search(params[:state]).map{|g| {id: g.id, text: g.code}}
	end

	def availables
		render json: batches.availables.where("LOWER(batches.code) ILIKE LOWER(?)", "%#{params[:q]}%").map{|b| {id: b.id, text: b.code}}
	end

	def new_clean_stock
	end

  # resetea el stock en 0 para el batch seleccionado
  def clean_stock
	if params[:password].present? && current_user.valid_password?(params[:password])
	  if batch.clean_stock
		redirect_to product_path(product, view: 'location'), notice: "Stock del lote #{batch.code} #{batch.serial} fue reiniciado correctamente"
	  else
	    redirect_to request.referer, alert: "No se puede actualizar el stock"
	  end
	else
	  redirect_to request.referer, alert: "Error al verificar el password"
	end
  end

end
