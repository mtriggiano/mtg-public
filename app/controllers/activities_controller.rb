class ActivitiesController < ApplicationController
	layout false, only: :show
	expose :parent,
		scope: 	->{ eval("current_company.#{params[:parent_class].downcase.pluralize}") },
		id: 	->{ params[:parent_id]},
		model: 	->{ params[:parent_class].constantize}
		
	expose :activities, ->{parent.activities}
	expose :activity, scope: -> {activities}

	include Indexable

	def	show
		@activity = current_company.activities.find(params[:id])
	end

end
