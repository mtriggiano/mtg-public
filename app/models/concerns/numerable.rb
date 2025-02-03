module Numerable
	extend ActiveSupport::Concern

	included do
		attr_accessor :share_numeration_with
		if column_names.include?("number")
			before_validation :set_number
			validates_numericality_of :number
			validates_length_of :number, :minimum => 3, :message => "Debe contener al menos 3 caracteres"
			validate :uniqueness_of_number
		end

		def self.search number
			if not number.blank?
				where("#{table_name}.number ILIKE ?", "%#{number}%")
			else
				all
			end
		end
	end

	def active_and_change
		active && number_changed?
	end

	def numbers
		if self.class.share_numeration_with
			self.class.unscope(where: :type).where(company_id: company_id, type: self.class.share_numeration_with).order(number: :asc).pluck(:number)
		else
			self.class.where(company_id: company_id).order(number: :asc).pluck(:number)
		end
	end

	def uniqueness_of_number
		if active_and_change
			errors.add(:base, "Error interno del servidor. Intente nuevamente") if numbers.include?(number)
		end
	end

	def set_number
  		self.number = ((numbers.last.to_i) + 1).to_s.rjust(8,padstr= '0') if self.number.blank?
	end

	class_methods do
		def share_numeration_with(value=nil)
			if value
				@share_numeration_with = value
			else
				@share_numeration_with
			end
		end
	end
end
