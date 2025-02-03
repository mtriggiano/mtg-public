class BankAccountMovement < ApplicationRecord
  #belongs_to :transaction, polymorphic: true
  belongs_to :bank_account
  belongs_to :supplier
end
