class ShipmentArrival < ApplicationRecord
  belongs_to :shipment, class_name: "ExternalShipment", inverse_of: :external_shipment_external_arrivals
  belongs_to :arrival, class_name: "ExternalArrival"
end
