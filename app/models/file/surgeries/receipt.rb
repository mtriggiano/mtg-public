class Surgeries::Receipt < ExpedientReceipt
	belongs_to 	:file, class_name: "Surgeries::File", foreign_key: :file_id
	belongs_to 	:client, foreign_key: :entity_id

	has_many 	:details, class_name: "Surgeries::ReceiptBill", foreign_key: :receipt_id, inverse_of: :receipt
	has_many :bills, through: :details
	has_many :responsables, through: :bills

	accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true

	validates_presence_of :details, message: "Debe indicar al menos una factura a pagar"

	after_save :handle_confirmation, :handle_anullment

	def handle_confirmation
		if confirmation?
    	PaymentsManager::ReceiptConfirmator.call(self)
			ClientManager::ReceiptConfirmator.call(self)
		end
  end

	def handle_anullment
		if anullment?
			PaymentsManager::ReceiptCancelator.call(self)
			ClientManager::ReceiptCancelator.call(self)
		end
	end

	def has_pdf?
    true
  end

	private

	def confirmation?
	  self.approved? &&  self.saved_change_to_state?
	end

	def anullment?
	  self.canceled? &&  self.saved_change_to_state?
	end
end
