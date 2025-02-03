class AddExternalFileIdToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :external_file_id, :bigint
  end
end
