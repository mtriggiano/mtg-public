class AddCompanyToNonWorkingDays < ActiveRecord::Migration[5.2]
  def change
    add_reference :non_working_days, :company, foreign_key: true
  end
end
