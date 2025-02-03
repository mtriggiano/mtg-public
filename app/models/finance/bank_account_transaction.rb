class BankAccountTransaction < ApplicationRecord
  belongs_to :bank_account
  belongs_to :user, optional: true

  validates_presence_of :fecha, :descripcion, :credito, :debito
  validates_numericality_of :credito, :debito, :saldo
end
