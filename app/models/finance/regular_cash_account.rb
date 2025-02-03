class RegularCashAccount < CashAccount
  has_many :imprest_clearings, foreign_key: :regular_cash_account_id
end
