class AddReportPermissionsToRoleAbilities < ActiveRecord::Migration[5.2]
  def up
    # Lista de permisos para reportes
    report_permissions = [
      { class_name: 'Reports::Bill', role_id: 1 },
      { class_name: 'Reports::Shipment', role_id: 1 },
      { class_name: 'Reports::ClientReport', role_id: 1 },
      { class_name: 'Reports::SellIvaMovement', role_id: 1 },
      { class_name: 'Reports::Purchase', role_id: 1 },
      { class_name: 'Reports::BuyIvaMovement', role_id: 1 },
      { class_name: 'Reports::Storage', role_id: 1 },
      { class_name: 'Reports::Receipt', role_id: 1 },
      { class_name: 'Reports::Finrep', role_id: 1 },
      { class_name: 'Reports::AllReports', role_id: 1 }
    ]

    # Crear cada permiso
    report_permissions.each do |permission|
      role_ability = RoleAbility.create(permission)
      if role_ability.persisted?
        puts "Creado RoleAbility para #{permission[:class_name]}"
      else
        puts "Error al crear RoleAbility para #{permission[:class_name]}"
      end
    end
  end

  def down
    # Eliminar permisos de reportes específicos
    report_classes = [
      'Reports::Bill', 'Reports::Shipment', 'Reports::ClientReport', 
      'Reports::SellIvaMovement', 'Reports::Purchase', 'Reports::BuyIvaMovement', 
      'Reports::Storage', 'Reports::Receipt', 'Reports::Finrep', 
      'Reports::AllReports'
    ]

    RoleAbility.where(class_name: report_classes).destroy_all
  end
end