class Department < ApplicationRecord
  belongs_to 	:company
  belongs_to 	:user
  has_many 		:file_movements, class_name: "ExpedientMovement"
  has_many 		:files, through: :file_movements

  validates :name, length: {maximum: 50, message: "El nombre del departamento es muy grande. Máximo 50 caracteres."}
  validates_presence_of :user_id, message: "Debe seleccionar un usuario."

  DEFAULTS = ["Compras", "Ventas", "Finanzas", "Almacen", "Logística", "Proveedores"]


end
