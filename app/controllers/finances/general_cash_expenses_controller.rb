class Finances::GeneralCashExpensesController < ApplicationController
  skip_load_and_authorize_resource
  before_action :set_permission
  expose :cash_account, id: -> { params[:cash_account_id] }
  expose :general_cash_expense

  def new

  end

  def create
    general_cash_expense = cash_account.general_cash_expenses.new(general_cash_expense_params)
    general_cash_expense.company = current_company
    general_cash_expense.forma   = cash_account.payment_types.find(params[:tipo_pago]).collect_type
    respond_to do |format|
      if general_cash_expense.save
        FinanceManager::ManualExpenseGenerator.call(general_cash_expense, cash_account.payment_types.find(params[:tipo_pago]))
        format.html{redirect_to polymorphic_path(general_cash_expense.cash_account, fecha: general_cash_expense.fecha), notice: "Gasto registrado correctamente."}
      else
        @general_cash_expense = general_cash_expense
        format.html{render :new }
      end
    end
  end

  private

  def set_permission
    authorize!(:manage, GeneralCashAccount)
    authorize!(:show, GeneralCashAccount)
    authorize!(:manage, RegularCashAccount)
    authorize!(:show, RegularCashAccount)
  end

  def general_cash_expense_params
    params.require(:general_cash_expense).permit(:descripcion, :fecha, :user_id, :importe, :lugar, :codigo, :forma)
  end
end
