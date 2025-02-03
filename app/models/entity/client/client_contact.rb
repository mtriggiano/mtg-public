class ClientContact < EntityContact
    belongs_to :client, foreign_key: :entity_id
    has_many :records, class_name: "ClientContactRecord", foreign_key: "entity_contact_id"
end
