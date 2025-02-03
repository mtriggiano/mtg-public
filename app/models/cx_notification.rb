# Este modelo solo existe para guardar registro de los id de expedientes que hayan sido enviados por email
# para evitar enviarlos mas de una vez.
# Tambien el usuario puede seleccionar un expediente para que ya no sea tenido en cuent para notificaciones.
# para eso agrega una nueva instancia en este modelo.
class CxNotification < ApplicationRecord
  belongs_to :fileable, polymorphic: true
end
