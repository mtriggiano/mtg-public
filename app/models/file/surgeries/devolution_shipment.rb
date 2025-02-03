class Surgeries::DevolutionShipment < ApplicationRecord
  self.table_name = :devolution_shipments
  belongs_to :devolution, class_name: "Surgeries::Devolution", foreign_key: :devolution_id, inverse_of: :devolutions_shipments
  belongs_to :shipment, class_name: "Surgeries::Shipment", optional: true, foreign_key: :shipment_id

  validates_presence_of :shipment, message: "Debe asociar al menos un remito de entrada"

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end
