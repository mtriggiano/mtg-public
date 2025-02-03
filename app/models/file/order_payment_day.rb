class OrderPaymentDay < ApplicationRecord
  belongs_to :payable, polymorphic: true
  belongs_to :payment_type
end
