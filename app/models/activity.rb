class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :company
  belongs_to :activitable, :polymorphic => true

  validates_presence_of :photo
  validates_presence_of :title
  validates_length_of   :title, maximum: 100
  validates_presence_of :body
  validates_length_of   :body, maximum: 500
end
