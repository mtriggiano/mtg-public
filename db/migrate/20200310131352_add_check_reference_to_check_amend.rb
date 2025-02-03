class AddCheckReferenceToCheckAmend < ActiveRecord::Migration[5.2]
  def change
    add_reference :check_amends, :emitted_check, foreign_key: true
  end
end
