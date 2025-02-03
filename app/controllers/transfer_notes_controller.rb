class TransferNotesController < ApplicationController

	skip_load_and_authorize_resource
	expose :store, scope: ->{ current_company.stores }
	expose :transfer_notes, 	->{ params[:store_id].blank? ? current_company.transfer_notes : store.transfer_notes }
	expose :transfer_note, scope: ->{ params[:store_id].blank? ? current_company.transfer_notes : store.transfer_notes }

	def index
  		respond_to do |format|
  			format.html
  			format.js
  			format.json { render json: TransferNoteDatatable.new(params, view_context: view_context, store: store), status: 200 }
  		end
  	end

	def show
	end

	def new
	end

	def edit
	end

	def create
		transfer_note.user_id = current_user.id
		respond_to do |format|
			if transfer_note.save
				format.html { redirect_to [:edit, transfer_note], notice: "Transferencia generada con éxito"}
			else
				pp transfer_note.errors
				format.html { render :new }
			end
		end
	end

	def update
		respond_to do |format|
			if transfer_note.update(transfer_note_params)
				format.html { redirect_to [:edit, transfer_note], notice: "Transferencia actualizada con éxito"}
			else
				format.html { render :edit }
			end
		end
	end

	def destroy
		respond_to do |format|
			if transfer_note.destroy
				format.html { redirect_to stores_external_path(transfer_note.store_id, view: 'transfers'), notice: "Transferencia actualizada con éxito"}
			else
				format.html { render :index }
			end
		end
	end

	private

		def transfer_note_params
			params.require(:transfer_note).permit(:number, :store_id, :sended_date, :arrival_date, :state, :observation,
				details_attributes: [:id, :product_id, :product_name, :quantity, :batch, :observation, :store_id, :store_line_id, :_destroy])
		end
end
