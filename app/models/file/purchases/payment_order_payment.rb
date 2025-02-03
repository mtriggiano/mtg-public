# Autor: Facundo Adrián Diaz Martinez
# CoAutor: Ariel Agustín García Sobrado
#
# Responsabilidad: modela los pagos (emitidos) en una orden de pago.
class Purchases::PaymentOrderPayment < ApplicationRecord
  self.table_name = "payment_order_payments"
  belongs_to :payment_order
  belongs_to :payment_type
  belongs_to :bank_account, optional: true ## Sólo para pagos de tipo transferencias bancarias
  belongs_to :checkbook, optional: true ## Sólo para pagos de tipo cheques

  validates_presence_of :payment_type_id, message: "Debe ingresar un tipo de pago"
	validate :promissory_payment_validation
  validate :transfer_payment_validation

  private

  def promissory_payment_validation
		if payment_type && payment_type.promesa_de_pago?
			errors.add(:base, "Seleccione una chequera.") if self.checkbook_id.blank?
			errors.add(:base, "Ingrese la fecha de vencimiento del cheque.") if self.due_date.blank?
			errors.add(:base, "Ingrese el número de cheque.") if self.number.blank?
		end
	end

  def transfer_payment_validation
		if payment_type && payment_type.transferencia?
			errors.add(:base, "Seleccione la cuenta bancaria (origen) de la transferencia.") if self.bank_account_id.blank?
			errors.add(:base, "Ingrese el número de referencia de la transferencia.") if self.number.blank?
		end
	end
end
