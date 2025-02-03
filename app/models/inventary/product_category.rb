class ProductCategory < ApplicationRecord
  belongs_to :company
  has_many :inventaries
  has_many :products
  has_many :boxes

  include Virtus.model(constructor: false, mass_assignment: false)

  attribute :current_user, User

  def to_s
    "#{name}"
  end
end
