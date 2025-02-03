class Purchases::PaymentOrdersController < ApplicationController
	include Fileable
	include Indexable
	include ShowPdf
	include BasicCrud

	before_action :set_current_user, except: :import

	def new
	  super
		payment_order.date = params[:date] || Date.today
	end

	def calendar
		@calendar = current_company.purchase_payment_orders.in_month(params[:start_date])
	end

	def import
		SupplierManager::MassivePaymentOrderImporter.new(params[:file], params[:supplier].to_i, params[:date].to_date, current_user).call
    respond_to do |format|
      	format.html { redirect_to request.referer, notice: 'Los datos están siendo cargados. En unos momentos estará listo' }
    end
	end

	private

	def payment_order_params
		params.require(:purchases_payment_order).permit(:entity_id, :file_id, :state, :date, :number, :total, :user_id, :concept, :observations,
			details_attributes: [:id, :bill_id, :total, :previous_debt, :total_left, :_destroy],
			payments_attributes: [:id, :_destroy, :payment_type_id, :bank_account_id, :checkbook_id, :total, :due_date, :number],
			taxes_attributes: [:id, :tipo, :total, :number, :_destroy])
	end
end
