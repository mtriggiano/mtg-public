class AlertsController < ApplicationController
	skip_load_and_authorize_resource
	expose :alerts, ->{ current_user.alerts }
	expose :alert, scope: ->{ alerts }
	

	def index
		alerts_ids = current_user.alerts.order(init_date: :desc).pluck(:id).last(10).push(Alert.where(user_id: current_user.id).order(init_date: :desc).pluck(:id).last(10)).flatten.uniq
		full_alerts = Alert.where(id: alerts_ids)
		if request.format.json?
			render json: AlertDatatable.new(params, view_context: view_context, collection: full_alerts), status: 200
		else
			authorize! :read, obj
		end
	end
end