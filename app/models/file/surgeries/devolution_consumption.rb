class Surgeries::DevolutionConsumption < ApplicationRecord
  self.table_name = :devolution_consumptions
  belongs_to :devolution, class_name: "Surgeries::Devolution", foreign_key: :devolution_id, inverse_of: :devolutions_consumptions
  belongs_to :consumption, class_name: "Surgeries::Consumption", optional: true, foreign_key: :consumption_id

  validates_presence_of :consumption, message: "Debe asociar al menos un remito de entrada"

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end
