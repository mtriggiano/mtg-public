class BillOptional < ApplicationRecord
  belongs_to :expedient_bill, foreign_key: :bill_id, inverse_of: :optionals
end
