class CreateNonWorkingDayDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :non_working_day_details do |t|
      t.references :non_working_day, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
