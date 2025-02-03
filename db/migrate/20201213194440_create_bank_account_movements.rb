class CreateBankAccountMovements < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_account_movements do |t|
      t.references :transaction, polymorphic: true, index: { name: :polymorphic_index }
      t.date :due_date
      t.date :emision
      t.integer :doc_type, null: false
      t.references :bank_account, foreign_key: true
      t.references :supplier, foreign_key: {to_table: :entities}
      t.integer :state, null: false
      t.string :observation
      t.decimal :total, null: false, scale: 2, precision: 10
      t.string :payments
      t.decimal :balance, null: false, scale: 2, precision: 10

      t.timestamps
    end
  end
end
