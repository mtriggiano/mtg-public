class RemovePdfNoteFromBills < ActiveRecord::Migration[5.2]
  def change
    remove_column :bills, :pdf_note, :text
  end
end
