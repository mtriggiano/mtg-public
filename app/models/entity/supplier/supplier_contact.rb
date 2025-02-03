class SupplierContact < EntityContact
	belongs_to :supplier, class_name: 'Supplier', foreign_key: "entity_id"
	has_many   :records, class_name: 'SupplierContactRecord', dependent: :destroy, foreign_key: "entity_contact_id"

	def self.search search
		if !search.blank?
			where("LOWER(supplier_contacts.name) ILIKE LOWER(?)", "%#{search}%")
		else
			all
		end
	end
end
