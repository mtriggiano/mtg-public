module Traceable
	extend ActiveSupport::Concern

	def new_batch_detail
		if params[:child] == "true"
			@detail = record.childs.where(id: params[:detail_id]).first_or_initialize
		else
			@detail = record.details.where(id: params[:detail_id]).first_or_initialize
		end
		@detail.batch_details.build unless @detail.batch_details.any?
		@index = params[:index]
		@random = rand(1..99999999)
	end

end
