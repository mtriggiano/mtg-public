class AddBankToEntities < ActiveRecord::Migration[5.2]
  def change
    add_column :entities, :bank, :string
    add_column :entities, :account, :string
    add_column :entities, :cbu, :string
  end
end
