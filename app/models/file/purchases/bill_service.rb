class Purchases::BillService < Purchases::BillDetail
	self.inheritance_column = :subtype
	self.ignored_columns = %w(product_id)
end
