class Expense < ApplicationRecord
  belongs_to :company
  belongs_to :user
  belongs_to :cash_account
  belongs_to :spendable, polymorphic: true, optional: true

  has_one :log, as: :logable, class_name: 'CashAccountLog', dependent: :destroy, foreign_key: :logable_id

  validates :importe,
    presence: { message: "Ingrese el importe." },
    numericality: { message: "El importe ingresado es incorrecto." }
  validates_presence_of :descripcion, message: "Ingrese la descripción de la transacción."
  validates_presence_of :fecha, message: "Ingrese la fecha."
  validate :only_business_day

  scope :daily, ->(fecha) { where(fecha: fecha) }

  after_create :genera_codigo_de_referencia, :genera_transaccion_de_caja

  def genera_transaccion_de_caja
    FinanceManager::ExpenseTransactionGenerator.call(self)
  end

  def descripcion_completa
    descripcion
  end

  def genera_codigo_de_referencia
  end

  def only_business_day
    errors.add(:fecha, "Solo se puede registrar en dias laborales.") if [6,0].include? fecha.to_date.wday
  end
end
