class GeneralCashAccount < CashAccount
  has_many :imprest_clearings, foreign_key: :general_cash_account_id
end
