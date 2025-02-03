class AddEstadoToCashSolicitude < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_solicitudes, :estado, :string
  end
end
