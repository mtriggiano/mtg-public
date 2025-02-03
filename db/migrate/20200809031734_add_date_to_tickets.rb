class AddDateToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :date, :date
  end
end
