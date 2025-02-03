class RebuildRoles < ActiveRecord::Migration[5.2]
  def change
    remove_reference :notifications, :role, foreign_key: true
    drop_table :user_abilities
    drop_table :role_abilities
    drop_table :abstract_roles
    drop_table :user_roles
    drop_table :roles
  end
end
