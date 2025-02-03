 module Alertable
	extend ActiveSupport::Concern

	included do
	 	skip_load_and_authorize_resource only: [:display_alerts, :new_alert, :edit_alert, :create_alert, :update_alert, :destroy_alert, :show_alert] 
	 	before_action :set_alert, only: [:edit_alert, :update_alert, :destroy_alert]
	 	helper_method :parent
	end

	def display_alerts
		@alerts = parent.alerts(current_user)
		respond_to do |format|
			format.js
			format.html
			format.json {render json: AlertDatatable.new(params, view_context: view_context, collection: @alerts), status: 200 }
		end
	end

	def new_alert
		@alert 	||= Alert.new()
		@url 	  = "/#{controller_path.underscore.pluralize}/#{parent.id}/create_alert"
		respond_to do |format|
			format.html { render template: '/alerts/new.html.haml', locals: {:@alert => @alert }}
		end
	end

	def edit_alert
		@url = "/#{controller_path.underscore.pluralize}/#{parent.id}/update_alert"
		respond_to do |format|
			format.html { render template: '/alerts/edit.html.haml', locals: {:@alert => @alert }}
		end
	end

	def create_alert
		if controller_path.classify == "Employees::User"
			obj = "User"
		else
			obj = controller_path.classify
		end
		@alert = ManageAlert.new(object_class: obj, parent_object_id: params[:id], params: alert_params, user: current_user).set
		respond_to do |format|
			if @alert.save
				flash.now[:notice] = "Actividad creada con éxito."
				format.js { render inline: "location.reload();" }
			else
				pp @alert.errors
				@url 	  = "/#{controller_path.underscore.pluralize}/#{parent.id}/create_alert"
				format.js {render template: '/alerts/new.js.erb'}
			end
		end
	end

	def update_alert
		respond_to do |format|
			if @alert.update(alert_params)
				flash.now[:notice] = "Actividad actualizada con éxito."
				format.js { render inline: "location.reload();" }
			else
				@url = "/#{controller_name.underscore.pluralize}/#{parent.id}/update_alert"
				format.js {render template: '/alerts/edit.js.erb'}
			end
		end
	end

	def destroy_alert
		respond_to do |format|
			if @alert.destroy
				format.html { redirect_to({action: :show, id: params[:id], view: "alerts"}, notice: "Actividad eliminada con éxito.")}
			else
				format.html { render :back}
			end
		end
	end

	def show_alert
		@alert  = current_company.alerts.find(params[:alert_id])
		respond_to do |format|
			format.html { render template: '/alerts/show.html.haml', locals: {:@alert => @alert }}
		end
	end

	private

		def set_alert
			@alert = current_company.alerts.find(params[:alert_id] || params[:id])
		end

		def alert_params
			params.require(:alert).permit(:title, :init_date, :final_date, :body, :observation, :state, alert_users_attributes: [:id, :user_id, :_destroy])
		end

		def parent
			eval("#{controller_name.snakecase.singularize}")
		end
end
