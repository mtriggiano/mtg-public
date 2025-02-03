class AddDescriptionToCashSolicitudes < ActiveRecord::Migration[5.2]
  def change
    add_column :cash_solicitudes, :descripcion, :text
  end
end
