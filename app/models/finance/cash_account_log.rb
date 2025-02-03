# Autor: Ariel Agustín García Sobrado
#
# Responsabilidad: Los logs de caja son las transacciones de caja en efectivo que pueden ser Ingresos o Egresos.
# Cada log se diferencia por FORMA de pago. Cada tipo de pago sumariza totales.
#
#
class CashAccountLog < ApplicationRecord
  belongs_to :cash_account
  belongs_to :user, optional: true
  belongs_to :logable, polymorphic: true ## Income o Expense

  FORMA = ["Efectivo ($)", "Efectivo (U$S)", "Efectivo (EUR)", "Cheque", "Pagaré", 'Tarjeta de crédito', 'Tarjeta de débito', 'Transferencia bancaria']

  validates_inclusion_of :forma, in: FORMA

  scope :incomes,           -> { where(flow: true) }
  scope :expenses,          -> { where(flow: false) }
  scope :efectivo,          -> { where(forma: ["Efectivo ($)", "Efectivo (U$S)"]) }
  scope :efectivo_pesos,    -> { where(forma: "Efectivo ($)") }
  scope :efectivo_dolares,  -> { where(forma: "Efectivo (U$S)") }
  scope :promesas,          -> { where(forma: ["Cheque", "Pageré"]) }
  scope :tarjeta,           -> { where(forma: ["Tarjeta de crédito", "Tarjeta de débito"]) }
  scope :transferencias,    -> { where(forma: "Transferencia bancaria") }
  scope :daily,             ->(fecha) { where(date: fecha) }

  def self.search data
    return all if data.blank?
    where("LOWER(description) LIKE :data OR monto::text = :data OR LOWER(codigo) LIKE :data OR LOWER(entidad) LIKE :data", data: "%#{data.downcase}%")
  end

  def chart_label_tag
    self.income? ? "Ingresos" : "Egresos"
  end

  def income?
    flow == true
  end

  def expense?
    !income?
  end

  def tarjeta?
    forma == 'Tarjeta de crédito' || forma == 'Tarjeta de débito'
  end

  def transferencia?
    forma == 'Transferencia bancaria'
  end
end
