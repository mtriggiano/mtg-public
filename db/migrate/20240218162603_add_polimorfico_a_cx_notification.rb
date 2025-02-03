class AddPolimorficoACxNotification < ActiveRecord::Migration[5.2]
  def change
    add_reference :cx_notifications, :fileable, polymorphic: true, index: true
  end
end
