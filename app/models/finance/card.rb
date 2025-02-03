class Card < ApplicationRecord
  belongs_to :company
  belongs_to :bank


  TYPES = [["Crédito", 'credit'], ["Débito", 'debit']]
  DELAY_TYPES = [["Hábiles", 'bussines_days'], ["Corridos", 'all_days']]
end
