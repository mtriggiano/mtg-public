class ChangeNameAmountInUserComissionRewards < ActiveRecord::Migration[5.2]
  def change
    rename_column :user_comission_rewards, :amount, :reward_percentage
  end
end
