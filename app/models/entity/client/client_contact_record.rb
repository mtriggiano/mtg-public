class ClientContactRecord < EntityRecord
    belongs_to :client_contact, class_name: "ClientContact", foreign_key: "entity_contact_id"
end
