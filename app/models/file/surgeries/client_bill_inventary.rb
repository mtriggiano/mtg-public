class Surgeries::ClientBillInventary < Surgeries::ClientBillDetail
	self.inheritance_column = :subtype
	include ProductDetails

end