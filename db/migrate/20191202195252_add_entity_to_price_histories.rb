class AddEntityToPriceHistories < ActiveRecord::Migration[5.2]
  def change
    add_reference :price_histories, :entity, foreign_key: true
  end
end
