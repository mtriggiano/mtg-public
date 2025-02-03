class AddCuentaMonedasToImprestClearing < ActiveRecord::Migration[5.2]
  def change
    add_column :imprest_clearings, :cuenta_monedas_a_rendir, :json
    add_column :imprest_clearings, :cuenta_monedas_saldo_en_caja, :json
  end
end
