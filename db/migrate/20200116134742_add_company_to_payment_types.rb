class AddCompanyToPaymentTypes < ActiveRecord::Migration[5.2]
  def change
    add_reference :payment_types, :company, foreign_key: true
  end
end
