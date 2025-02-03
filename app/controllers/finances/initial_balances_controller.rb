class Finances::InitialBalancesController < ApplicationController
  expose :cash_account, id: -> { params[:cash_account_id] }
  expose :initial_balance

  def create
    initial_balance = cash_account.initial_balances.new(initial_balance_params)
    initial_balance.user      = current_user
    initial_balance.fecha     = Date.today
    initial_balance.balance   = 0
    initial_balance.cuenta_monedas = params[:cuenta_monedas]
    if initial_balance.save
      redirect_to cash_account, notice: "Apertura de caja registrado."
    else
      pp initial_balance.errors
      render :new
    end
  end

  private

  def initial_balance_params
    params.require(:initial_balance).permit(:importe)
  end
end
