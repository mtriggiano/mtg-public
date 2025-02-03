class AddCodigoToCashSolicitude < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_solicitudes, :codigo, :string
  end
end
