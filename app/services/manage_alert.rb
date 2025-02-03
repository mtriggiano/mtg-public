class ManageAlert

	def initialize(args={})
		@user 				= args[:user]
		@params 			= args[:params]
		@parent 			= args[:parent]
		@id 				= args[:id]
		@parent_object_id 	= args[:parent_object_id]
		@for_object_class	= args[:object_class]
	end

	def create
		set.save
	end

	def set
		alert 					= ::Alert.new(@params)
		alert.user_id 			= @user.id
		alert.company_id 		= @user.company_id
		alert.alertable_type 	= @for_object_class
		alert.alertable_id		= @parent_object_id
		return alert
	end

	def display
		if @user.present? && (@user.can?(:manage, :all) || @user.can?(:manage, @for_object_class))
			Alert.where(alertable_type: @for_object_class, alertable_id: @parent_object_id)
		else
			if @user.present? && @for_object_class.blank?
				Alert.joins(:users).where("alerts_users.user_id = ?", user.id)
			elsif @user.present? && !@for_object_class.blank?
				Alert.joins(:users).where(alertable_type: @for_object_class, alertable_id: @parent_object_id).where("alerts_users.id = ?", @user.id)
			else
				Alert.where(alertable_type: @for_object_class, alertable_id: @parent_object_id)
			end
		end
	end


	def cumpliment
		alert = Alert.find_by_id(id)
		alert.update_column(:state, "Finalizada")
	end

	def assign_to_users users_ids
		users_ids.each {|id| UserAlert.create(alert_id: params[:id], user_id: id) }
	end

	def destroy
		Alert.where(for_object_class: for_object_class, parent_object_id: parent_object_id).destroy_all
	end

end
