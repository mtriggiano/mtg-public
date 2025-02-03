class AddCorrectionCoefficientForNetAmountToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :coefficient_for_net_amount, :float, default: 0.74
  end
end
