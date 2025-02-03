class Surgeries::DevolutionArrival < ApplicationRecord
  belongs_to :devolution, class_name: "Surgeries::Devolution", foreign_key: :devolution_id, inverse_of: :devolutions_external_arrivals
  belongs_to :external_arrival, class_name: "ExternalArrival", foreign_key: :arrival_id, optional: true

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end
