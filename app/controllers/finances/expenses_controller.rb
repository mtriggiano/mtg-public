class Finances::ExpensesController < ApplicationController
  expose :expenses, ->{ current_company.general_cash_account.logs.expenses }
  expose :expense
  include Indexable
  skip_load_and_authorize_resource

  def show
    redirect_to_spendable(expense) if expense.spendable
  end

  private

  def redirect_to_spendable(expense)
    case expense.spendable_type
    when "Purchases::PaymentOrder"
      redirect_to edit_purchases_payment_order_path(expense.spendable_id)
    when "ExpedientReceipt"
      redirect_to edit_expedient_receipt_path(expense.spendable_id)
    when "CashSolicitude"
      redirect_to cash_solicitude_path(expense.spendable_id)
    when "ExpenseDetail"
      redirect_to expense_detail_path(expense.spendable_id)
    end
  end
end
