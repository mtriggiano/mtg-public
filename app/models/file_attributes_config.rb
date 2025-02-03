class FileAttributesConfig < ApplicationRecord
    belongs_to :company

    validates_presence_of :parent_model
    after_save :set_custom_attributes_to_model

    def extra_attribute_sym
        extra_attribute.parameterize.underscore.to_sym
    end

    def set_custom_attributes_to_model
      FileAttributesConfig.where(parent_model: parent_model).pluck(:extra_attribute).each do |key|
           parent_model.classify.constantize.store_accessor :custom_attributes, key.parameterize.underscore.to_sym
      end
    end
end
