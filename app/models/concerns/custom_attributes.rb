module CustomAttributes
	extend ActiveSupport::Concern

	included do
		before_save :remove_blanks

		def remove_blanks
		    self.custom_attributes = self.custom_attributes.reject{ |k,v| v.blank? } unless custom_attributes.nil?
		end

		def has_custom_attributes?
			eval("company.#{self.class.name.snakecase.split("/").map(&:singularize).join("_")}_configs").any?
		end
	end

end
