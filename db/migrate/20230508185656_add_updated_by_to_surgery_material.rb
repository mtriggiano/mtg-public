class AddUpdatedByToSurgeryMaterial < ActiveRecord::Migration[5.2]
  def change
  	add_reference :surgery_materials, :updated_by, foreign_key: { to_table: :users }
  end
end
