class AddNoteAndStickerToFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :files, :need_surgical_sheet, :boolean, null: false, default: false
    add_column :files, :need_implant, :boolean, null: false, default: false
    add_column :files, :need_note, :boolean, null: false, default: false
    add_column :files, :need_sticker, :boolean, null: false, default: false
  end
end
