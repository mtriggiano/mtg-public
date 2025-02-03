class AddDescriptionToExpedientBillTributes < ActiveRecord::Migration[5.2]
  def change
    add_column :tributes, :description, :string
  end
end
