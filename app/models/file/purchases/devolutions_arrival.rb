class Purchases::DevolutionsArrival < ApplicationRecord
  self.table_name = :devolutions_arrivals
  belongs_to :devolution, class_name: "Purchases::Devolution", foreign_key: :devolution_id, inverse_of: :devolutions_external_arrivals
  belongs_to :external_arrival, class_name: "ExternalArrival", optional: true, foreign_key: :arrival_id

  validates_presence_of :external_arrival, message: "Debe asociar al menos un remito de entrada"

  before_validation :set_type

  def set_type
    self.type = self.class.name
  end
end
