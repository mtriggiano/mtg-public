class CreateNonPresentUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :non_present_users do |t|
      t.references :attendance, foreign_key: true
      t.references :user, foreign_key: true
      t.date :date
    end
  end
end
