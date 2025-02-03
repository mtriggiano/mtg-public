class AddAttributesToEntity < ActiveRecord::Migration[5.2]
  def change
    add_column :entities, :denomination, :string
    add_reference :entities, :payment_type, foreign_key: true
    add_column :entities, :payment_days, :integer
    add_reference :entities, :province, foreign_key: true
    add_reference :entities, :locality, foreign_key: true
    add_column :entities, :cp, :string
  end
end
