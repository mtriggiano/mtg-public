class ChangeNameToUnitGtins < ActiveRecord::Migration[5.2]
  def change
    rename_table "unit_gtins", "gtins"
  end
end
