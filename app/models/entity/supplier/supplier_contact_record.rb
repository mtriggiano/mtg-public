class SupplierContactRecord < EntityRecord
	belongs_to :supplier_contact, class_name: 'SupplierContact', foreign_key: "entity_contact_id"
	default_scope ->{where.not(entity_contact_id: nil)}
end
