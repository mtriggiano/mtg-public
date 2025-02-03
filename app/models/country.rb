class Country < ApplicationRecord
  has_many :provinces, dependent: :destroy
  has_many :localities, through: :provinces
end
