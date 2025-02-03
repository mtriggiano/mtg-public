class AddSalePointToImprestSystem < ActiveRecord::Migration[5.2]
  def change
    add_reference :imprest_systems, :sale_point, foreign_key: true
  end
end
