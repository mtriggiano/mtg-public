class Purchases::PaymentOrderBill < ApplicationRecord
	self.table_name = "payment_order_bills"
	belongs_to :payment_order, class_name: "Purchases::PaymentOrder", inverse_of: :details
	belongs_to :bill, class_name: "ExternalBill", optional: true

	before_validation :set_previous_debt

	validates_presence_of :payment_order, message: "Debe vincular una orden de pago"
	validates_presence_of :total, message: "Debe esecificar el total"
	validates_numericality_of :total, message: "Total inválido"
	validates_presence_of :total_left, message: "Debe especificar el total faltante"
	validates_presence_of :previous_debt, message: "Saldo anterior faltante"
	validates_numericality_of :total_left, message: "Total faltante inválido"
	validates_numericality_of :previous_debt, message: "Saldo anterior inválido"
	validates_uniqueness_of :bill, scope: :payment_order_id

	validate :total_menor_a_factura

	def set_childs_parent
		return true
	end

	def total_left
		read_attribute(:total_left) || bill.total_pay
	end

	private

	def set_previous_debt
		if self.bill
			self.previous_debt = self.bill.total_left_for_reports
		else
			self.previous_debt = 0
		end
	end

	def total_menor_a_factura
		unless self.bill_id.blank?
			errors.add(:base, "El importe a pagar no puede superar el saldo de la factura.") if self.total.to_f.round(2) > self.bill.real_total_left.to_f.round(2)
		end
	end

end
