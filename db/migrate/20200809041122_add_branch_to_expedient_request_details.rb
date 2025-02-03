class AddBranchToExpedientRequestDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :request_details, :branch, :string
  end
end
