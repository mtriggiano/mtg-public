class Gtin < ApplicationRecord
    has_many :batches, dependent: :destroy
    has_many :arrival_details, class_name: "ExpedientArrivalDetail"
    validates_presence_of    :code, message: "No puede estar en blanco"
    scope :availables, ->{ where("gtins.available > 0") }

    accepts_nested_attributes_for :batches, reject_if: :all_blank, allow_destroy: true

    def self.search state
      if state.blank?
        all
      else
        where(state: state)
      end
    end

    def traceable?
        inventary || inventray.traceable
    end

    def inventary
        return nil if batches.blank?
        Product.find(batches.map(&:product_id).last)
    end

    def unavailable?
        !state
    end

    def name
        "GTIN: #{code}"
    end

    def is_available?
      state
    end

  end
