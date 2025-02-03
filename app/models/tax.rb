class Tax < ApplicationRecord
  belongs_to :taxable, polymorphic: true
  validates_presence_of :total, message: "Debe especificar el total"
  validates_presence_of :tipo, message: "Tipo inválido"
  validates :total, numericality: {min: 0, message: "El valor mìnimo es 0"}

  before_validation :set_company

  def set_company
  	self.company_id = taxable.company_id
  end
end
