class Finances::CashWithdrawalsController < ApplicationController
  skip_load_and_authorize_resource
  before_action :set_permission
  expose :cash_solicitude, id: -> { params[:cash_solicitude_id] }
  expose :cash_withdrawal

  def create
    cash_withdrawal         = cash_solicitude.build_cash_withdrawal(cash_withdrawal_params)
    cash_withdrawal.user_id = current_user.id
    cash_withdrawal.fecha   = Date.today
    if cash_withdrawal.save
      FinanceManager::WithdrawalExpenseGenerator.call(cash_withdrawal)
      redirect_to general_cash_account_path(current_company.general_cash_account, view: 'pendings'), notice: 'Retiro registrado.'
    else
      render :new
    end
  end

  private

  def set_permission
    authorize!(:manage, CashSolicitude)
  end

  def cash_withdrawal_params
    params.require(:cash_withdrawal).permit(:importe)
  end
end
