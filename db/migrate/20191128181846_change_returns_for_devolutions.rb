class ChangeReturnsForDevolutions < ActiveRecord::Migration[5.2]
  def change
    rename_table :returns, :devolutions
    rename_table :return_details, :devolution_details
    rename_column :devolution_details, :return_id, :devolution_id
    rename_column :devolution_details, :return_detail_id, :devolution_detail_id
    rename_table :returns_arrivals, :devolutions_arrivals
    rename_column :devolutions_arrivals, :return_id, :devolution_id
    rename_column :gtins, :return_detail_id, :devolution_detail_id
  end
end
