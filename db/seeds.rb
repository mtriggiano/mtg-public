# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

country 	= Country.where(name: "Argentina").first_or_create
province 	= Province.where(name: "Salta", country_id: country.id).first_or_create
locality 	= Locality.where(name: "Capital", province_id: province.id).first_or_create

# company_role = Role.where(class_name: "Company", active: true).first_or_create
# 	RoleAbility.where(action_name: "show", 		description: "Ver el detalle de la compañia", 	role_id: company_role.id).first_or_create
# 	RoleAbility.where(action_name: "update", 	description: "Actualizar datos de la compañía", role_id: company_role.id).first_or_create
#
# #MOVIMIENTOS DE EXPEDIENTE
# movement = []
# movement << Role.where(class_name: "Surgeries::FileMovement", active: true).first_or_create
# movement << Role.where(class_name: "Purchases::FileMovement", active: true).first_or_create
# movement << Role.where(class_name: "Sales::FileMovement", active: true).first_or_create
# movement.each do |doc|
# 	RoleAbility.where(action_name: "manage", 	description: "Acceso total", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "read", 		description: "Ver el índice", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "show", 		description: "Ver el detalle", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "update", 	description: "Actualizar", 							role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "create", 	description: "Crear", 								role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "destroy", 	description: "Eliminar", 							role_id: doc.id).first_or_create
# end
# #INVENTARIO
# inventary = []
# inventary << Role.where(class_name: "ProductCategory", active: true).first_or_create
# inventary << Role.where(class_name: "Product", active: true).first_or_create
# inventary << Role.where(class_name: "Box", active: true).first_or_create
# inventary.each do |doc|
# 	RoleAbility.where(action_name: "manage", 	description: "Acceso total", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "read", 		description: "Ver el índice", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "show", 		description: "Ver el detalle", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "update", 	description: "Actualizar", 							role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "create", 	description: "Crear", 								role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "destroy", 	description: "Eliminar", 							role_id: doc.id).first_or_create
# end
#
# #PROVEEDORES
# supplier = []
# supplier << Role.where(friendly_name: "Proveedores", class_name: "Supplier", active: true).first_or_create
# supplier << Role.where(friendly_name: "Contacto de proveedores", class_name: "SupplierContact", active: true).first_or_create
# supplier << Role.where(friendly_name: "Registro de contacto con proveedores", class_name: "ContactRecord", active: true).first_or_create
# supplier.each do |doc|
# 	RoleAbility.where(action_name: "manage", 	description: "Acceso total", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "read", 		description: "Ver el índice", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "show", 		description: "Ver el detalle", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "update", 	description: "Actualizar", 							role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "create", 	description: "Crear", 								role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "destroy", 	description: "Eliminar", 							role_id: doc.id).first_or_create
# end
#
# #CLIENTES
# client = []
#
# client << Role.where(friendly_name: "Clientes", class_name: "Client", active: true).first_or_create
# client << Role.where(friendly_name: "Contactos de clientes", class_name: "ClientContact", active: true).first_or_create
# client << Role.where(friendly_name: "Registro deontactos con clientes", class_name: "ClientContactRecord", active: true).first_or_create
# client.each do |doc|
# 	RoleAbility.where(action_name: "manage", 	description: "Acceso total", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "read", 		description: "Ver el índice", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "show", 		description: "Ver el detalle", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "update", 	description: "Actualizar", 							role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "create", 	description: "Crear", 								role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "destroy", 	description: "Eliminar", 							role_id: doc.id).first_or_create
# end
#
# #CIRUGIAS
# surgery = []
# surgery << Role.where(friendly_name: "Cirugía: Expedientes", class_name: "Surgeries::File", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Recetas/Solicitudes", class_name: "Surgeries::Prescription", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Cotizaciones", class_name: "Surgeries::Budget", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Ordenes de venta", class_name: "Surgeries::SaleOrder", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Solicitudes de compra", class_name: "Surgeries::PurchaseRequest", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Ingresos de stock", class_name: "Surgeries::Arrival", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Salidas de stock", class_name: "Surgeries::Shipment", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Consumos de stock", class_name: "Surgeries::Consumption", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Ordenes de compra", class_name: "Surgeries::PurchaseOrder", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Facturación", class_name: "Surgeries::ClientBill", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Recibos", class_name: "Surgeries::Receipt", active: true).first_or_create
# surgery << Role.where(friendly_name: "Cirugía: Pago a proveedores", class_name: "Surgeries::SupplierBill", active: true).first_or_create
#
# surgery.each do |doc|
# 	RoleAbility.where(action_name: "manage", 	description: "Acceso total", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "approve", 	description: "Aprobar/Rechazar",					role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "reopen", 	description: "Reapertura", 							role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "read", 		description: "Ver el índice", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "show", 		description: "Ver el detalle", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "update", 	description: "Actualizar", 							role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "create", 	description: "Crear", 								role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "destroy", 	description: "Eliminar", 							role_id: doc.id).first_or_create
# end
#
# #VENTAS
# sale = []
# sale << Role.where(friendly_name: "Ventas: Expedientes", class_name: "Sales::File", active: true).first_or_create
# sale << Role.where(friendly_name: "Ventas: Solicitudes", class_name: "Sales::SaleRequest", active: true).first_or_create
# sale << Role.where(friendly_name: "Ventas: Cotizaciones", class_name: "Sales::Budget", active: true).first_or_create
# sale << Role.where(friendly_name: "Ventas: Ordenes de venta", class_name: "Sales::Order", active: true).first_or_create
# sale << Role.where(friendly_name: "Ventas: Salidas de stock", class_name: "Sales::Shipment", active: true).first_or_create
# sale << Role.where(friendly_name: "Ventas: Facturación", class_name: "Sales::Bill", active: true).first_or_create
#
# sale.each do |doc|
# 	RoleAbility.where(action_name: "manage", 	description: "Acceso total", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "approve", 	description: "Aprobar/Rechazar",					role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "reopen", 	description: "Reapertura", 							role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "read", 		description: "Ver el índice", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "show", 		description: "Ver el detalle", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "update", 	description: "Actualizar", 							role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "create", 	description: "Crear", 								role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "destroy", 	description: "Eliminar", 							role_id: doc.id).first_or_create
# end
#
# #COMPRAS
#
# purchase = []
# purchase << Role.where(friendly_name: "Compras: Expedientes", class_name: "Purchases::File", active: true).first_or_create
# purchase << Role.where(friendly_name: "Compras: Solicitudes", class_name: "Purchases::PurchaseRequest", active: true).first_or_create
# purchase << Role.where(friendly_name: "Compras: Cotizaciones", class_name: "Purchases::Budget", active: true).first_or_create
# purchase << Role.where(friendly_name: "Compras: Ordenes de compras", class_name: "Purchases::Order", active: true).first_or_create
# purchase << Role.where(friendly_name: "Compras: Salidas de stock", class_name: "Purchases::Arrival", active: true).first_or_create
# purchase << Role.where(friendly_name: "Compras: Pago a proveedores", class_name: "Purchases::Bill", active: true).first_or_create
#
# purchase.each do |doc|
# 	RoleAbility.where(action_name: "manage", 	description: "Acceso total", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "approve", 	description: "Aprobar/Rechazar",					role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "reopen", 	description: "Reapertura", 							role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "read", 		description: "Ver el índice", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "show", 		description: "Ver el detalle", 						role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "update", 	description: "Actualizar", 							role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "create", 	description: "Crear", 								role_id: doc.id).first_or_create
# 	RoleAbility.where(action_name: "destroy", 	description: "Eliminar", 							role_id: doc.id).first_or_create
# end

