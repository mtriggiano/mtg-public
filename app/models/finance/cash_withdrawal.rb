class CashWithdrawal < ApplicationRecord
  belongs_to :cash_solicitude
  belongs_to :user

  validates_presence_of :importe, message: "Ingrese el importe del retiro."
  validates_presence_of :fecha, message: "La fecha ingresada es incorrecta."
end
