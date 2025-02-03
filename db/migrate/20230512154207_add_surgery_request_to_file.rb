class AddSurgeryRequestToFile < ActiveRecord::Migration[5.2]
  def change
  	add_reference :surgery_requests, :file, null: true
  end
end
