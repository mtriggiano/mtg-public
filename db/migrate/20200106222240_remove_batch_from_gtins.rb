class RemoveBatchFromGtins < ActiveRecord::Migration[5.2]
  def change
    remove_reference :gtins, :batch, foreign_key: true
    remove_reference :batches, :entity, foreign_key: true
    remove_reference :batches, :product, foreign_key: true
    remove_reference :batches, :arrival_detail, foreign_key: true
    remove_reference :batches, :user, foreign_key: true
    remove_column :batches, :store_id, :bigint
    remove_column :batches, :available, :float
    remove_column :batches, :due_date, :date

    add_reference :batches, :gtin, foreign_key: true
    add_reference :batches, :arrival_detail, foreign_key: true
    add_reference :batches, :shipment_detail, foreign_key: true
    add_column :batches, :transaction_id, :integer
    add_column :batches, :serial, :string
    add_column :batches, :state, :boolean, default: true
    add_column :batches, :due_date, :date

    remove_reference :gtins, :product, foreign_key: true
    remove_reference :gtins, :arrival_detail, foreign_key: true
    remove_reference :gtins, :shipment_detail, foreign_key: true
    remove_column :gtins, :devolution_detail_id, :bigint
    remove_column :gtins, :state, :string
    remove_column :gtins, :transaction_id, :integer
    remove_column :gtins, :serial, :string

  end
end
