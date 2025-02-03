class ExpedientReceiptBill < ApplicationRecord
	self.table_name = :receipts_bills
	belongs_to :receipt, class_name: "ExpedientReceipt", foreign_key: :receipt_id, inverse_of: :receipt_details
	belongs_to :bill, -> {where(type: ['Sales::Bill', 'Tenders::Bill', 'Surgeries::ClientBill'])},class_name: "ExpedientBill", foreign_key: :bill_id, optional: true

	validates_presence_of :total, message: "Debe especificar el total"
	validates_presence_of :total_left, message: "El monto faltante es inválido"
	validates_numericality_of :total, message: "Total inválido"

	after_save :assign

	scope :a_cuenta, -> { where(bill_id: nil) }

	def set_childs_parent
		return true
	end

	def total_left
		read_attribute(:total_left) || bill.total_pay
	end

	def self.fix_db
		where(bill_id: nil).update_all("available_to_assign = total")
		ids = ExpedientBill.joins(:receipts).where(total_pay: 0).map{|a| a.receipts.map(&:id)}.flatten
		ExpedientReceiptBill.joins(:receipt).where(receipts: {id: ids}).each do |detail|
			if detail.total >= detail.bill.total_left
				detail.update_column(:available_to_assign, detail.total - detail.bill.total_left)
				detail.bill.update_columns(total_pay: detail.bill.total_left, total_left: 0)
			else
				detail.bill.increment!(:total_pay, detail.total)
				detail.bill.increment!(:total_left, -detail.total)
				detail.update_column(:available_to_assign, 0)
			end
		end

	end

	def assign
		if !receipt.saved_change_to_state? && receipt.approved?
			if bill.total_left >= available_to_assign
				update_column(:available_to_assign, 0)
				bill.increment!(:total_left, -available_to_assign)
				bill.increment!(:total_pay, available_to_assign)
			else
				increment!(:available_to_assign, -bill.total_left)
				bill.update_columns(total_left: 0, total_pay: bill.total)
			end
		end
	end

end
