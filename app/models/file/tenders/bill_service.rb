class Tenders::BillService < Tenders::BillDetail
	self.inheritance_column = :subtype
	self.ignored_columns = %w(product_id)
end