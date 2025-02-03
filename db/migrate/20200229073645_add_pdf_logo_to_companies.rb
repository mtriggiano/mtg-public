class AddPdfLogoToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :pdf_logo, :string
  end
end
