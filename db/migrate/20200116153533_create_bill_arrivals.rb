class CreateBillArrivals < ActiveRecord::Migration[5.2]
  def change
    create_table :bill_arrivals do |t|
      t.references :bill, foreign_key: true
      t.references :arrival, foreign_key: true
      t.string :type

      t.timestamps
    end
  end
end
