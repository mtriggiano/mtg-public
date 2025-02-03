class ShipmentRequest < ApplicationRecord
  belongs_to :shipment
  belongs_to :request
end
