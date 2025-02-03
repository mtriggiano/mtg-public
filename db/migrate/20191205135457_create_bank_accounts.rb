class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.string :alias_tag
      t.string :type
      t.string :number, null: false
      t.string :cbu, null: false
      t.references :bank, foreign_key: true

      t.timestamps
    end
  end
end
