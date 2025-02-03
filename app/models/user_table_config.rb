class UserTableConfig < ApplicationRecord
    belongs_to :user
    has_many :hidden_attributes

    def self.custom_hidden_attributes(table)
        config = where(table: table).first_or_create
        config.hidden_attributes.map(&:col)
    end
  end
