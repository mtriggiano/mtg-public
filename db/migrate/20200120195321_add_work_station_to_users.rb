class AddWorkStationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :work_station, foreign_key: true
  end
end
