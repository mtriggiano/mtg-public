class ChangeBankDefaults < ActiveRecord::Migration[5.2]
  def change
    change_column :banks, :active, :boolean, default: true
  end
end
