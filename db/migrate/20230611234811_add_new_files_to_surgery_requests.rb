class AddNewFilesToSurgeryRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :surgery_requests, :father_dni, :string
    add_column :surgery_requests, :mother_dni, :string
    add_column :surgery_requests, :father_anses_negative, :string
    add_column :surgery_requests, :mother_anses_negative, :string
  end
end
