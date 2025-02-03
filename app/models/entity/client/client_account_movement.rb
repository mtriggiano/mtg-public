class ClientAccountMovement < AccountMovement
  belongs_to :client, foreign_key: "entity_id"
  belongs_to :bill, ->{where(type: ["Sales::Bill", "Surgeries::ClientBill", "Tenders::Bill"])} ,optional: true, class_name: "GeneralBill", foreign_key: "bill_id"
  belongs_to :receipt, optional: true, class_name: "ExpedientReceipt", foreign_key: "receipt_id"

  def parent
  	bill_id.blank? ? :receipt : :bill
  end

  def self.create_from_receipt receipt
    new() do |am|
      am.receipt_id       = receipt.id
      am.entity_id        = receipt.entity_id
      am.cbte_tipo        = receipt.name(:short)
      am.flow             = "expense"
      am.total            = receipt.is_finished? ? receipt.total.round(2) : -receipt.total.round(2)
      am.balance          = receipt.client.current_balance.round(2) - am.total
      am.save
    end
  end

  def self.update_dates
    ClientAccountMovement.all.each do |am|
      movement_parent = eval("am.#{am.parent.to_s}")
      am.update_column(:date, movement_parent.date) unless movement_parent.nil?
    end
  end
end
