class Surgeries::ReceiptsController < ApplicationController
  	include Attachable
  	include Fileable
  	include CanAddDetail
  	include Indexable
  	include ClientFilter
  	include ShowPdf
  	include Reopen
  	include BasicCrud

		def index 
			expedient = Surgeries::File.find params[:file_id]
			receipts_id = expedient.client_bills.includes(:receipts).map{|bill| bill.receipts.pluck(:id) }.flatten
			receipts = Surgeries::Receipt.where(id: receipts_id)

			respond_to do |format|
				format.html
				format.json { render json: Surgeries::ReceiptDatatable.new(params, view_context: view_context, collection: receipts ) }
			end
		end
	private

		def receipt_params
			params.require(:surgeries_receipt).permit(:entity_id, :file_id, :concept, :sale_point_id, :state, :date, :concept, :state, :number, :total, :user_id,
				details_attributes: [:id, :bill_id, :total_left, :payment_type, :number, :due_date, :total, :_destroy],
        		custom_attributes: current_company.surgery_receipt_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
      		)
		end

end
