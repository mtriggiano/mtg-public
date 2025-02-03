class ChangeSalePointInBills < ActiveRecord::Migration[5.2]
  def change
    change_column :bills, :sale_point, :string, null: true
  end
end
