class AccountMovement < ApplicationRecord
  belongs_to :bill, class_name: 'GeneralBill', optional: true
  belongs_to :receipt, class_name: 'ExpedientReceipt', optional: true

  FLOW = ["income", "expense"]

  validates :flow,
    presence: true,
    inclusion: { in: FLOW }

  scope :incomes, -> { where(flow: "income") }
  scope :expenses, -> { where(flow: "expense") }

  def income?
    flow == "income"
  end

  def expense?
    !income?
  end
end
