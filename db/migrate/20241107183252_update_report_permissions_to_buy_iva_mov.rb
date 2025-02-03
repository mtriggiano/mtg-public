class UpdateReportPermissionsToBuyIvaMov < ActiveRecord::Migration[5.2]
  def up
    # Actualiza los registros existentes en RoleAbility
    RoleAbility.where(class_name: 'Reports::BuyIvaMovement').update_all(class_name: 'Reports::BuyIvaMov')
  end

  def down
    # Revertir los cambios en caso de rollback
    RoleAbility.where(class_name: 'Reports::BuyIvaMov').update_all(class_name: 'Reports::BuyIvaMovement')
  end
end