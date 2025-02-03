class DailyCashBalance < ApplicationRecord
  belongs_to :cash_account
  belongs_to :user

  include Finance::CordersCounter ## contador de monedas

  validates :fecha,
    presence: { message: "Fecha incorrecta." },
    uniqueness: { scope: [:cash_account, :type], message: "Arqueo registrado previamente para la fecha informada." }
  validates :importe,
    presence: { message: "Importe faltante." },
    numericality: { greater_than_or_equal_to: 0, message: "La cantidad en caja NO puede ser menor a 0." }

  scope :aperturas, -> { where(apertura: true) }
  scope :cierres, -> { where(apertura: false) }
  scope :daily, ->(fecha) { where(fecha: fecha) }

  def daily fecha
    begin
      date = Date.parse(fecha) && fecha.count("/") == 2
    rescue
      date = Date.today
    end
    where(fecha: date)
  end
end
