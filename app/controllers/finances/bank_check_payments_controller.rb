class Finances::BankCheckPaymentsController < ApplicationController
  skip_load_and_authorize_resource
  before_action :set_permission
  expose :bank_check_payments, ->{current_company.bank_check_payments}
	expose :bank_check_payment, scope: ->{bank_check_payments}

	def create
		if bank_check_payment.save
      PaymentsManager::BankCheckChanger.call(bank_check_payment.old_bank_check, bank_check_payment, current_user) if bank_check_payment.cheque_reemplazado?
			redirect_to promissory_payment_path(bank_check_payment), notice: "Cheque registrado."
		else
			render :show
		end
	end

	def update
		if bank_check_payment.update(bank_check_payment_params)
			redirect_to promissory_payment_path(bank_check_payment), notice: "Cheque registrado."
		else
			render :edit
		end
	end

  def collect
    if not bank_check_payment.cobrado?
      if bank_check_payment.update(params.require(:bank_check_payment).permit(:bank_account_id))
        PaymentsManager::PromissoryPaymentCollector.call(bank_check_payment, current_user)
        redirect_to current_company.general_cash_account, notice: "Depósito de cheque/pagaré registrado."
      else
        render :show
      end
    else
      render :show
    end
  end

	private

  def set_permission
    authorize!(:manage, GeneralCashAccount)
  end

	def bank_check_payment_params
		params.require(:bank_check_payment).permit(:old_bank_check_id, :numero_cheque, :vencimiento, :entity_id, :concepto, :importe)
	end
end
