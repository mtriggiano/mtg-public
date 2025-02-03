class ExpedientReceiptPayment < ApplicationRecord
  self.table_name = :receipts_payments
  belongs_to :receipt, class_name: "ExpedientReceipt", foreign_key: :receipt_id, inverse_of: :payments
  belongs_to :payment_type
  belongs_to :bank_account, optional: true

  validate :promissory_payment_validation
  validate :transfer_payment_validation

  def promissory_payment_validation
    if payment_type && payment_type.promesa_de_pago?
      errors.add(:number, "Ingrese el número de cheque o pagaré.") if number.blank?
      errors.add(:due_date, "Ingrese la fecha de vencimiento del cheque o pagaré.") if due_date.blank?
    end
	end

  def transfer_payment_validation
    if payment_type && payment_type.transferencia?
      errors.add(:bank_account_id, "Seleccione la cuenta bancaria (destino) del pago.") if bank_account_id.blank?
      errors.add(:number, "Ingrese el número de referencia de la transferencia.") if number.blank?
    end
	end
end
