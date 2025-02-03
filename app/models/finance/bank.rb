class Bank < ApplicationRecord
  belongs_to :company
  has_many :bank_accounts
  has_many :cards
  has_many :checkbooks, through: :bank_accounts
end
