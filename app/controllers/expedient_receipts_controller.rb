class ExpedientReceiptsController < ApplicationController
	include Attachable
	include Fileable
	include CanAddDetail
	include Indexable
	include ClientFilter
	include ShowPdf
	include BasicCrud
	# include Reopen
	before_action :set_current_user, except: :import

	def new
	  if params[:pay_bill]
			invoice = current_company.expedient_bills
				.approveds
				.unpaid
				.not_credito_notes
				.where(id: params[:pay_bill])

			if invoice.any?
				expedient_receipt.entity_id = invoice.first.entity_id

				expedient_receipt.details.destroy_all
				expedient_receipt.details.new(
					bill_id: params[:pay_bill].to_i,
					total_left: invoice.first.real_total_left,
					total: invoice.first.real_total_left
				)
			end
	  end
		expedient_receipt.payments.build if expedient_receipt.payments.empty?
		expedient_receipt.date = Date.today
	end


	def assign_bill_to
		@unpaid_bills = expedient_receipt.client.bills
			.approveds.unpaid.not_credito_notes.map{ |bill| ["#{bill.full_name} - SALDO ACTUAL: $#{bill.total_left}", bill.id] }
	end

	def destroy
	  if expedient_receipt.pending?
			expedient_receipt.rejected!
			redirect_to request.referer, notice: "Recibo rectificado."
		else
			pp record.errors if Rails.env == "development"
			redirect_to request.referer, notice: "El recibo no puede ser marcado como Rectificado."
	  end
	end

	def import
		ClientManager::MassiveReceiptImporter.new(params[:file], params[:client].to_i, params[:date].to_date, current_user).call
    respond_to do |format|
      	format.html { redirect_to request.referer, notice: 'Los datos están siendo cargados. En unos momentos estará listo' }
    end
	end

	private

		def expedient_receipt_params
			params.require(:expedient_receipt).permit(:entity_id, :client_payment_order, :file_id, :concept, :state, :date, :concept, :state, :number, :total, :user_id, :observation,
				receipt_details_attributes: [:id, :bill_id, :payment_type_id, :total, :total_left,  :number, :due_date, :_destroy],
				taxes_attributes: [:id, :tipo, :total, :number, :_destroy],
				payments_attributes: [:id, :payment_type_id, :total, :number, :due_date, :bank_account_id, :real_date, :_destroy],
        		custom_attributes: current_company.surgery_receipt_configs.pluck(:extra_attribute).map{|attribute| attribute.parameterize.underscore.to_sym},
      		)
		end
end
