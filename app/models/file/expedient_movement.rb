class ExpedientMovement < ApplicationRecord
    self.table_name = :file_movements
  	belongs_to :department
  	belongs_to :sender, class_name: "User", foreign_key: :sended_by
  	belongs_to :receiver, class_name: "User", foreign_key: :received_by, optional: true

    include Restricted
  	before_save :set_create_params, on: :create

  	def set_create_params
  		self.sended_at = Time.now
  	end

    def self.search(file_id)
      if !file_id.blank?
        where("#{table_name}.file_id ILIKE ?", "%#{file_id}%")
      else
        all
      end
    end
end
