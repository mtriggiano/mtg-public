class Finances::PromissoryNotePaymentsController < ApplicationController
  skip_load_and_authorize_resource
  before_action :set_permission
  expose :promissory_note_payments, ->{current_company.promissory_note_payments}
	expose :promissory_note_payment, scope: ->{promissory_note_payments}

	def create
		if promissory_note_payment.save
      PaymentsManager::BankCheckChanger.call(promissory_note_payment.old_bank_check, promissory_note_payment, current_user) if promissory_note_payment.cheque_reemplazado?
			redirect_to promissory_payment_path(promissory_note_payment), notice: "pagaré registrado."
		else
      pp promissory_note_payment.errors
			render :show
		end
	end

	def update
		if promissory_note_payment.update(promissory_note_payment_params)
			redirect_to promissory_payment_path(promissory_note_payment), notice: "Pagaré registrado."
		else
			render :edit
		end
	end

  def collect
    if not promissory_note_payment.cobrado?
      PaymentsManager::PromissoryPaymentCollector.call(promissory_note_payment, current_user)
      redirect_to current_company.general_cash_account, notice: "Depósito de pagaré registrado."
    else
      render :show
    end
  end

	private

  def set_permission
    authorize!(:manage, GeneralCashAccount)
  end

	def promissory_note_payment_params
		params.require(:promissory_note_payment).permit(:old_bank_check_id, :numero_cheque, :vencimiento, :entity_id, :concepto, :importe)
	end
end
