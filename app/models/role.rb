class Role < ApplicationRecord
  include Virtus.model(constructor: false, mass_assignment: false)
  belongs_to :company
  has_many :abilities, class_name: "RoleAbility", inverse_of: :role, dependent: :destroy
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :abilities, reject_if: :all_blank, allow_destroy: true

  attribute :current_user, User
  validates :name, presence: {message: "Debe especificar un nombre"}, uniqueness: {scope: :company_id, message: "Ya existe"}
end
