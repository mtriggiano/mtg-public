class NotificationsController < ApplicationController
	skip_load_and_authorize_resource
	layout false, only: :index
	expose :notifications, ->{ current_user.notifications.order("seen desc, created_at desc") }
	expose :notification, scope: ->{notifications}
	after_action :reset_notification_counter, only: :index

  	def index
      if request.format.json?
        render json: AlertDatatable.new(params, view_context: view_context, collection: notifications), status: 200
      else
        #authorize! :read, notifications
      end
    end

  	def show; end

  	private

  		def reset_notification_counter
  			current_user.notifications.unseen.update_all(seen: true)
  		end

end
