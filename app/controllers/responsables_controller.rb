class ResponsablesController < ApplicationController
	skip_load_and_authorize_resource only: :index
	expose :responsables, -> { current_user.responsables }
	expose :responsable, scope: ->{ responsables }

	def index
		if request.format.json?
			render json: AlertDatatable.new(params, view_context: view_context, collection: responsables), status: 200
		else
			authorize! :read, obj
		end
	end

end
