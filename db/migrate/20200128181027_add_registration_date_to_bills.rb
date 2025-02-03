class AddRegistrationDateToBills < ActiveRecord::Migration[5.2]
  def change
    add_column :bills, :registration_date, :date
  end
end
