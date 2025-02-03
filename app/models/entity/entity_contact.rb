class EntityContact < ApplicationRecord
  	has_many   :budgets
  	has_many   :entity_records, dependent: :destroy
    belongs_to :entity, foreign_key: :entity_id

    def self.search_by attr, search
        if not search.blank?
            where("#{table_name}.#{attr} ILIKE ?", "%#{search}%")
        else
            all
        end
    end
end
