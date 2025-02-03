class RemoveBudgetedFromRequestDetails < ActiveRecord::Migration[5.2]
  def change
    remove_column :request_details, :budgeted, :boolean
  end
end
