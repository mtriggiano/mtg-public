class Location < ApplicationRecord
  belongs_to :shipment, class_name: "ExpedientShipment", inverse_of: :location
end
