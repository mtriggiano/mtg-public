class AddFilesToSurgeryRequests < ActiveRecord::Migration[5.2]
  def change
  	add_column :surgery_requests, :dni, :string
  	add_column :surgery_requests, :anses_negative, :string
  	add_column :surgery_requests, :anses_no_negative, :string
  	add_column :surgery_requests, :surgical_sheet, :string
  	add_column :surgery_requests, :codem, :string
  	add_column :surgery_requests, :clinical_record_cover, :string
  	add_column :surgery_requests, :implant_certificate, :string
  end
end
