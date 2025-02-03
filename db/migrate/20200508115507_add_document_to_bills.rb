class AddDocumentToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :document_type, :string
    add_column :bills, :document_number, :string
  end
end
