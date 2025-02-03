class ExpedientOrderCustomDetail < ApplicationRecord

  self.table_name = :order_details

  default_scope ->{where(custom_detail: true)}
  before_validation :set_values

  def set_values
  	self.product_code ||= 0
  	self.product_measurement ||= "Unidad"
  end

end