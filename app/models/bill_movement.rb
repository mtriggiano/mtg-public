class BillMovement < ApplicationRecord
  belongs_to :bill, class_name: "ExpedientBill"
  include Virtus.model(mass_assignment: false, constructor: false)
  attribute :current_user, User

  before_save :set_bill_name, :set_client

  def set_bill_name
    self.bill_name = bill.full_name
  end

  def set_client
    self.client = bill.client.try(:name)
  end
end
