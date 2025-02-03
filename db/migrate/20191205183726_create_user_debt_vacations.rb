class CreateUserDebtVacations < ActiveRecord::Migration[5.2]
  def change
    create_table :user_debt_vacations do |t|
      t.references :user, foreign_key: true
      t.integer :year
      t.integer :days
    end
  end
end
