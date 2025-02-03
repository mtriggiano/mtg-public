class SalePoint < ApplicationRecord
  belongs_to :company
  has_one :imprest_system

  def self.activity
  	group_by_day_of_week(:created_at, format: "%a").count
  end
end
