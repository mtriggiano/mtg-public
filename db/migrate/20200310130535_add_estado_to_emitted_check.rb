class AddEstadoToEmittedCheck < ActiveRecord::Migration[5.2]
  def change
    add_column :emitted_checks, :estado, :string
  end
end
