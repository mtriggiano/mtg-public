class Locality < ApplicationRecord
  has_many :companies
  belongs_to :province


  def self.set_locality locality, province_id
    is_number = locality.to_f.to_s == locality.to_s || locality.to_i.to_s == locality.to_s
    if is_number
      return Locality.find(locality)
    else
      loc = Locality.where(name: locality, province_id: province_id).first_or_create
      return loc.id
    end
  end
end
