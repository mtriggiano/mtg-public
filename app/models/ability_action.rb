class AbilityAction < ApplicationRecord
  belongs_to :ability, class_name: "RoleAbility", foreign_key: :ability_id, inverse_of: :ability_actions

  def self.first_or_build(attributes = nil, options = {}, &block)
    first || build(attributes, options, &block)
  end
end
