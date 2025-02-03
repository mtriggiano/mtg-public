class AddDeliverToHospitalToRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :deliver_to_hospital, :date
  end
end
