class DeliveryNotesController < ApplicationController
	expose :delivery_notes, ->{current_company.delivery_notes}
	expose :delivery_note, scope: ->{current_company.delivery_notes}
  include Indexable
  include Reopen


  	def show
      respond_to do |format|
        format.html
        format.js
        format.pdf do
          @group_details = delivery_note.details.includes(:product).in_groups_of(20, fill_with= nil)
          render pdf: "#{delivery_note.id}",
          layout: 'pdf.html',
          template: 'delivery_notes/show',
          viewport_size: '1280x1024',
          page_size: 'A4',
          encoding:"UTF-8"
        end
      end
    end

  	def new
  		unless params[:purchase_return_id].blank?
  			delivery_note.assign_details_from_purchase_return(params[:purchase_return_id])
  		end
  	end

  	def edit
  		unless params[:purchase_return_id].blank?
  			delivery_note.assign_details_from_purchase_return(params[:purchase_return_id])
  		end
  	end

  	def create
  		if delivery_note.save
  			redirect_to edit_delivery_note_path(delivery_note.id), notice: "Remito creado con éxito"
  		else
  			render :new
		end
	end

	def update
		if delivery_note.update(delivery_note_params)
			redirect_to edit_delivery_note_path(delivery_note.id), notice: "Actualizacion exitosa"
		else
			render :edit
		end
	end

	def destroy
		if delivery_note.destroy
			redirect_to delivery_notes_path, notice: "Se eliminó el remito con éxito"
		else
			render :show
		end
	end

  	private

		def delivery_note_params
      params.require(:delivery_note).permit(:store_id, :purchase_file_id, :number, :purchase_return_id, :user_id, :date, :state, :observation,
        details_attributes: [:id, :product_id, :product_name, :product_supplier_code, :returned_quantity, :batch_id, :observation, :_destroy]
      )
		end
end
