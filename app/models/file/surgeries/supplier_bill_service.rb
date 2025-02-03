class Surgeries::SupplierBillService < Surgeries::SupplierBillDetail
	self.inheritance_column = :subtype
	self.ignored_columns = %w(product_id)
end