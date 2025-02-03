class BankAccount < ApplicationRecord
  self.inheritance_column = nil
  belongs_to :bank

  has_one :configuration, class_name: "BankAccountImporterConfiguration"
  has_many :checkbooks
  has_many :emitted_checks
  has_many :bank_check_payments
  has_many :transactions, foreign_key: :bank_account_id, class_name: "BankAccountTransaction"
  has_many :bank_transfer_payments, class_name: "ExpedientReceiptPayment"
  has_many :emitted_transfer_payments, class_name: "Purchases::PaymentOrderPayment"

  ACCOUNT_TYPES = [
    "Cuenta corriente en pesos",
    "Cuenta corriente en dólares",
    "Caja de ahorro en dólares",
    "Caja de ahorro en pesos",
    "Cuenta especial en pesos",
    "Cuenta especial en dólares"
  ]

  validates_presence_of :number, message: "El número de cuenta no puede estar vacío."
  validates_uniqueness_of :number, scope: :bank, message: 'El número de cuenta ya está en uso para este banco.'
  validates :cbu,
    presence: { message: "El C.B.U. no puede estar vacío." },
    numericality: { message: "El C.B.U. debe ser numérico." },
    length: { is: 22, message: "El C.B.U. debe contener 22 dígitos." }

end
