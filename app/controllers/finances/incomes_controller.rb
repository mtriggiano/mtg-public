class Finances::IncomesController < ApplicationController
  expose :incomes, ->{ current_company.general_cash_account.logs.incomes }
  expose :income
  include Indexable
  skip_load_and_authorize_resource

  def show
    redirect_to_spendable(income) if income.spendable
  end

  private

  def redirect_to_spendable(income)
    case income.spendable_type
    when "ExpedientReceipt"
      redirect_to edit_expedient_receipt_path(income.spendable_id)
    when "CashSolicitude"
      redirect_to cash_solicitude_path(income.spendable_id)
    end
  end
end
