class Sales::ReceiptsController < ApplicationController
	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include ShowPdf
	include BasicCrud

	def index 
		expedient = Sales::File.find params[:file_id]
		receipts_id = expedient.bills.includes(:receipts).map{|bill| bill.receipts.pluck(:id) }.flatten
		receipts = Sales::Receipt.where(id: receipts_id)

		respond_to do |format|
      format.html
      format.json { render json: Sales::ReceiptDatatable.new(params, view_context: view_context, collection: receipts ) }
    end
	end
	private

		def receipt_params
			params.require(:sales_receipt).permit(:entity_id, :file_id, :concept, :sale_point_id, :state, :date, :concept, :state, :number, :total, :user_id,
				details_attributes: [:id, :bill_id, :payment_type_id, :total, :total_left,  :number, :due_date, :_destroy],
        		custom_attributes: current_company.surgery_receipt_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
      		)
		end
end
