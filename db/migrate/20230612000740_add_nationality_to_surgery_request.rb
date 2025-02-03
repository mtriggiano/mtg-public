class AddNationalityToSurgeryRequest < ActiveRecord::Migration[5.2]
  def change
  	add_column :surgery_requests, :nationality, :string
  end
end
