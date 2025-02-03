class AgreementSurgeries::SurgeryMaterial < ApplicationRecord
  self.table_name = :surgery_materials
  include Virtus.model(mass_assignment: false, constructor: false)
  belongs_to :company
  belongs_to :user, optional: true
  belongs_to :updated_by, class_name: "User", optional: true

  has_many :surgery_request_details

  attribute  :current_user, User

  validates :code, presence: true
  validates :description, presence: true
  validates :category, presence: true
  validates :origin, presence: true
  validates :active, presence: false

  validates :price, presence: true
  validates :maximum_price, presence: true
  validates :minimum_price, presence: true
  validates :minimum_price, :maximum_price, numericality: { greater_than_or_equal_to: 0 }
  validates :minimum_price, numericality: { less_than: :maximum_price, message: 'El precio mínimo debe ser menor que el precio máximo' }

  has_paper_trail only: [:price, :minimum_price, :maximum_price]

  ORIGEN_NACIONAL = "NACIONAL"
  ORIGEN_IMPORTADO = "IMPORTADO"
  ORIGENES = [
    ORIGEN_NACIONAL,
    ORIGEN_IMPORTADO
  ]

  def self.update_prices(percent)
    error = nil
    begin
      AgreementSurgeries::SurgeryMaterial.all.each do |surgery_material|
        new_price = surgery_material.price * (1 + (percent / 100))
        new_min_price = surgery_material.minimum_price * (1 + (percent / 100))
        new_max_price = surgery_material.maximum_price * (1 + (percent / 100))
        surgery_material.update(price: new_price, minimum_price: new_min_price, maximum_price: new_max_price) 
      end
    rescue => e
      puts ap e.record.as_json if e.try(:record)
      error = e.message
    end
    return [error == nil, error]
  end

  def to_s
    "#{self.description}"
  end

  def self.search search
    return all if search.blank?
    where("LOWER(description) ILIKE LOWER(?)", "%#{search}%")
  end

end
