class AddCheckTypeToEmittedChecks < ActiveRecord::Migration[5.2]
  def change
    add_column :emitted_checks, :check_type, :string, default: "Cheque"
  end
end
