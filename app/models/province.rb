class Province < ApplicationRecord
  belongs_to :country
  has_many :localities, dependent: :destroy
end
