class AddArrivalDetailToGtins < ActiveRecord::Migration[5.2]
  def change
    add_reference :gtins, :arrival_detail, foreign_key: true
  end
end
