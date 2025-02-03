class AddAreaToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :area, :string
  end
end
