class RemoveSalePointReferenceFromExpedientReceipt < ActiveRecord::Migration[5.2]
  def change
    remove_reference :receipts, :sale_point
  end
end
