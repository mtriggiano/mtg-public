class AgreementSurgeries::PriceUpdate < ApplicationRecord
  include Virtus.model(mass_assignment: true, constructor: false)
  belongs_to :created_by, class_name: "User", optional: true
  belongs_to :company
  belongs_to :user, optional:true
	
  attribute  :current_user, User

  validates :percent, presence: true

  def actualizar
  	AgreementSurgeries::SurgeryMaterial.update_prices(percent)
  end
end
