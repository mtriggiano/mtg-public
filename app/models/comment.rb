class Comment < ApplicationRecord
  belongs_to :articleable, polymorphic: true
  belongs_to :user
end
