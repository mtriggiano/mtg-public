class AddDeliveryDateToFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :files, :delivery_date, :date
    add_column :files, :delivery_hour, :time
    add_column :files, :technical, :string	
  end
end
