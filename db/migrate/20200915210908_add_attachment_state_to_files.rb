class AddAttachmentStateToFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :files, :surgical_sheet_state, :integer, null: false, default: 0
    add_column :files, :implant_state, :integer, null: false, default: 0
  end
end
