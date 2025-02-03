class GeneralBill < ApplicationRecord

	include HasDetails
	self.table_name  = :bills
	self.abstract_class = true
	self.inheritance_column = :_type_disabled

	def has_pdf?
    false
  end
end
