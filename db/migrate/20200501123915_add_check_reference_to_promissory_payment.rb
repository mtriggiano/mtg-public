class AddCheckReferenceToPromissoryPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :promissory_payments, :old_bank_check_id, :bigint, index: true, foreign_key: true
  end
end
