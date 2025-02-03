class BatchStore < ApplicationRecord
  belongs_to :batch
  belongs_to :store

  validates_uniqueness_of :batch_id, scope: :store_id
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :by_store, -> (store_id) { where(store_id: store_id).first }
end
