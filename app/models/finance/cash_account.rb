class CashAccount < ActiveRecord::Base
  belongs_to :company
  belongs_to :user, optional: true

  has_many :logs, class_name: "CashAccountLog"
  has_many :initial_balances
  has_many :general_cash_expenses
  has_many :general_cash_incomes
  has_many :imprest_incomes
  has_many :expenditures, class_name: "CashAccountExpenditure"
  has_many :payment_types

  def nuevo_balance! valor
    self.saldo = valor
    self.save!
  end

  
end
