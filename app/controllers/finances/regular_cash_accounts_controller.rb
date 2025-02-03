class Finances::RegularCashAccountsController < ApplicationController
  expose :regular_cash_accounts, -> { current_company.regular_cash_accounts }
  expose :regular_cash_account,  scope: -> { regular_cash_accounts }
  expose :transactions,          -> { regular_cash_account.logs.search(params[:search]).order(id: :desc).includes(:user) }
  expose :initial_balances,      -> { regular_cash_account.initial_balances.daily(params[:search]) }
  expose :imprest_clearings, -> { regular_cash_account.imprest_clearings.includes(:user, :regular_cash_account).search(params[:search]).order(fecha: :desc) }
  expose :payment_types, -> { regular_cash_account.payment_types }
  expose :expenditures,   -> { regular_cash_account.expenditures.search(params[:search]) }

  def show
    rendiciones = imprest_clearings.confirmados
    if rendiciones.empty?
      @transactions = transactions
    else
      @transactions = transactions.where("cash_account_logs.created_at >= ?", rendiciones.first.tiempo_de_confirmacion)
    end
    @previous_transactions = transactions.order("created_at DESC").paginate(page: params[:previous_page], per_page: 30)
  end

end
