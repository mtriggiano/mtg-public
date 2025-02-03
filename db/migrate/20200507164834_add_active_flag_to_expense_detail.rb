class AddActiveFlagToExpenseDetail < ActiveRecord::Migration[5.2]
  def change
    add_column :expense_details, :disabled_time, :datetime
    add_column :expense_details, :disable_user_id, :bigint, foreign_key: true
  end
end
