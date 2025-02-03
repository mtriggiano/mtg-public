class Surgeries::ConsumptionShipment < ApplicationRecord
  self.table_name = :consumptions_shipments
  
  belongs_to :consumption, 
  				class_name: "Surgeries::Consumption", 
  				foreign_key: :consumption_id, 
  				inverse_of: :consumptions_shipments
  belongs_to :shipment, class_name: "Surgeries::Shipment", foreign_key: :shipment_id, inverse_of: :consumption_shipments, optional: true

  before_validation :set_type

  validates_presence_of :shipment, message: "Debe asociar una salida"

  def set_type
    self.type = self.class.name
  end
end
