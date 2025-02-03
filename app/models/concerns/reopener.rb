module Reopener
	extend ActiveSupport::Concern
	included do
		store_accessor :custom_attributes, :reopen
		def can_be_opened_by? user
      if defined?(file) && file != nil
  		  responsables.include?(user) || (defined?(file) != nil && file.user == user) || user.can?(:reopen, self)
      else
        user.can?(:reopen, self)
      end
  	end

  	def reopened?
			reopen
  	end

		def can_be_reopened?
			ov_classes = ["Sales::Order", "Surgeries::SaleOrder", "Tenders::Order"]

			if ov_classes.include?(self.class.to_s)
				if self.approved? && self.try(:shipments).approveds.any?
					return true if [1653, 1163, 1862, 1707, 1951, 1706].include? self.file_id
					return false
				else
					return true
				end
			else
				return true
			end
		end
  end
end
