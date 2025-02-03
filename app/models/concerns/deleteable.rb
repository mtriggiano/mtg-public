module Deleteable
	extend ActiveSupport::Concern

	def destroy(mode = :soft)
	    if mode == :hard
	      	super()
	    else
	    	self.run_callbacks :destroy do
	    		if self.errors.empty?
		    		self.update_column(:active, false)
		    	else
		    		return false
		    	end
		    end
		    self.freeze
	    end
	end
end
