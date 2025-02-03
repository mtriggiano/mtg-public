class AddClassificationToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :classification, :string
  end
end
