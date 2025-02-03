class CreateNonWorkingDays < ActiveRecord::Migration[5.2]
  def change
    create_table :non_working_days do |t|
      t.date :date
      t.string :reason
      t.string :holiday_type
    end
  end
end
