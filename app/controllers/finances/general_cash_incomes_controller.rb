class Finances::GeneralCashIncomesController < ApplicationController
  skip_load_and_authorize_resource
  before_action :set_permission
  expose :cash_account, id: -> { params[:cash_account_id] }
  expose :general_cash_income

  def create
    general_cash_income         = cash_account.general_cash_incomes.new(general_cash_income_params)
    general_cash_income.company = current_company
    general_cash_income.forma   = cash_account.payment_types.find(params[:tipo_pago]).collect_type
    if general_cash_income.save
      FinanceManager::ManualIncomeGenerator.call(general_cash_income, cash_account.payment_types.find(params[:tipo_pago]))
      redirect_to polymorphic_path(general_cash_income.cash_account, fecha: general_cash_income.fecha), notice: "Ingreso registrado correctamente."
    else
      pp general_cash_income.errors
      render :new
    end
  end

  private

  def set_permission
    authorize!(:manage, cash_account)
  end

  def general_cash_income_params
    params.require(:general_cash_income).permit(:descripcion, :fecha, :user_id, :importe, :lugar, :forma, :codigo)
  end
end
