class AddSubtateToExpedients < ActiveRecord::Migration[5.2]
  def change
    add_column :files, :substate, :string
  end
end
