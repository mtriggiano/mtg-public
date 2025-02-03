class AddTypeToRequestDetails < ActiveRecord::Migration[5.2]
  def change
    add_column :request_details, :type, :string
  end
end
