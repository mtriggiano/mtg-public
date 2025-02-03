class CreateSurgeryRequestDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :surgery_request_details do |t|
      t.references :surgery_request, foreign_key: true
      t.string :surgery_material
      t.float :quantity
      
      t.timestamps
    end
  end
end
