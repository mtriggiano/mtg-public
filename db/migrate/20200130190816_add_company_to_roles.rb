class AddCompanyToRoles < ActiveRecord::Migration[5.2]
  def change
    add_reference :roles, :company, foreign_key: true
  end
end
