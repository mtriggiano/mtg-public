class AddPdfnoteToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :pdf_note, :text
  end
end
