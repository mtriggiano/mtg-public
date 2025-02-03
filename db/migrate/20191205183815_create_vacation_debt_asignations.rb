class CreateVacationDebtAsignations < ActiveRecord::Migration[5.2]
  def change
    create_table :vacation_debt_asignations do |t|
      t.bigint :user_vacation_id
      t.bigint :user_debt_vacation_id
      t.integer :days
    end
  end
end
