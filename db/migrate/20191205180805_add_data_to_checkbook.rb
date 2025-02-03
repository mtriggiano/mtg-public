class AddDataToCheckbook < ActiveRecord::Migration[5.2]
  def change
    add_reference :checkbooks, :bank_account, foreign_key: true
    add_column :checkbooks, :serie, :string
    add_column :checkbooks, :monto_acumulado, :decimal, precision: 10, scale: 2
  end
end
