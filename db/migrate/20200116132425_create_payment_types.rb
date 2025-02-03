class CreatePaymentTypes < ActiveRecord::Migration[5.2]
  def change
  	drop_table :payment_types
    create_table :payment_types do |t|
      t.string :name, null: false
      t.boolean :imputed_in_cash, null: false, default: true

      t.timestamps
    end
  end
end
