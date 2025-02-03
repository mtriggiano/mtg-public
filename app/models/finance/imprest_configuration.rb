class ImprestConfiguration < ApplicationRecord
  belongs_to :cash_account, class_name: "RegularCashAccount"

  validates :fondo_fijo,
    presence: { message: "Debe ingresar el monto del fondo fijo." },
    numericality: { greater_than: 0, message: "El monto del fondo fijo debe ser mayor a $0." }
end
