class AddNombreSolicitanteToCashSolicitude < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_solicitudes, :nombre_solicitante, :string
  end
end
