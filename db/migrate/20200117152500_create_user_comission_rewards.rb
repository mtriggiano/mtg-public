class CreateUserComissionRewards < ActiveRecord::Migration[5.2]
  def change
    create_table :user_comission_rewards do |t|
      t.references :user, foreign_key: true
      t.float :amount, default: 0.0
      t.string :percentage, default: "80%"
      t.timestamps
    end
  end
end
