class Request

	def initialize(request, state)
		@request 	= request
		@state 		= state
	end

	def change_state
		if set_details_state
			@request.update_column(:state, @state)
		end
	end

	def set_details_state
		@request.details.update_all(state: @state)
	end
end