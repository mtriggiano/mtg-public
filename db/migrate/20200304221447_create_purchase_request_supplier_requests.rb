class CreatePurchaseRequestSupplierRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :purchase_request_supplier_requests do |t|
      t.bigint :purchase_request_id, foreign_key: true
      t.bigint :supplier_request_id, foreign_key: true

      t.timestamps
    end

    add_index :purchase_request_supplier_requests, [:purchase_request_id, :supplier_request_id], unique: true, name: :request_request_index
  end
end
