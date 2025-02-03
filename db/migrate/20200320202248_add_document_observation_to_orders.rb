class AddDocumentObservationToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :document_observation, :text
  end
end
