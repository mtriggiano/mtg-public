class EntityRecord < ApplicationRecord
    belongs_to :user
    belongs_to :entity_contact
end
