class AddSurgicalSheetStateToFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :files, :surgical_sheet_state_2, :integer, null: false, default: 0
    add_column :files, :need_surgical_sheet_2, :boolean, null: false, default: false
  end
end
