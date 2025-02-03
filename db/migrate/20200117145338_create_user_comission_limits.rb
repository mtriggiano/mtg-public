class CreateUserComissionLimits < ActiveRecord::Migration[5.2]
  def change
    create_table :user_comission_limits do |t|
      t.references :user, foreign_key: true
      t.float :amount
      t.string :period
      t.timestamps
    end
  end
end
