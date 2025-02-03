class AddIdToBudgetsRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :budgets_requests, :id, :primary_key
  end
end
