class AddIdMedtronicToClients < ActiveRecord::Migration[5.2]
  def change
  	add_column :entities, :id_medtronic, :string
  end
end
