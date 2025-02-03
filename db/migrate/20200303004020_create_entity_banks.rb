class CreateEntityBanks < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_banks do |t|
      t.references :entity, foreign_key: true
      t.string :cbu, null: false, limit: 22
      t.string :alias, null: false, limit: 200
      t.string :cuit, null: false, limit: 22
      t.string :name, null: false, limit: 200
      t.string :account_type, null: false, limit: 200
      t.string :branch_office, limit: 200
      t.string :denomination, limit: 200

      t.timestamps
    end
  end
end
