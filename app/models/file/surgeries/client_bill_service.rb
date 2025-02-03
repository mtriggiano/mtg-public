class Surgeries::ClientBillService < Surgeries::ClientBillDetail
	self.inheritance_column = :subtype
	self.ignored_columns = %w(product_id)
end