class RemoveUnusedDataFromCheckbook < ActiveRecord::Migration[5.2]
  def change
    remove_column :checkbooks, :bank_id, :string
    remove_column :checkbooks, :company_id, :string
  end
end
