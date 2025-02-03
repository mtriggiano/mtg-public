class AddLogeableToCashAccountLog < ActiveRecord::Migration[5.2]
  def change
    add_reference :cash_account_logs, :logable, polymorphic: true
  end
end
