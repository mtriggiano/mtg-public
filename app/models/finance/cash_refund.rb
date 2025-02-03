class CashRefund < ApplicationRecord
  belongs_to :cash_solicitude
  belongs_to :user

  validates_presence_of :importe
  validates_presence_of :fecha
end
