class AddSurgeryEndDateToFiles < ActiveRecord::Migration[5.2]
  def change
    add_column :files, :surgery_end_date, :date
  end
end
