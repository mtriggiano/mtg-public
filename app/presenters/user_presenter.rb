class UserPresenter < BasePresenter
	presents :user
	#delegate :role, to: :user
	delegate :status, to: :user
	delegate :id, to: :user
	delegate :first_name, to: :user
	delegate :last_name, to: :user
	delegate :document_number, to: :user
	delegate :email, to: :user
	delegate :attendance_resumes, to: :user
	delegate :file_number, to: :user
	delegate :address, to: :user

	def name
		#TODO Cuando se cree el perfil del usuario agregar el path al final.
		link_to "#{image_tag user.avatar, class: 'img-fluid border rounded-circle table-avatar'} #{user.name}".html_safe, "#"
	end

	def role
		handle_none(user.roles.map{|r| r.name}.join(", "))
	end

	def phone
		handle_none(user.phone)
	end

	def contract
	  handle_none(user.contract)
	end

	def start_of_activity
	  handle_date(user.start_of_activity)
	end

	def birthday
	  handle_date(user.birthday)
	end

	def work_station_name
	  if user.work_station.nil?
			"Sin especificar"
		else
			user.work_station.name
		end
	end

	def hours_worked_in_month
		attr =attendance_resumes.where(month: Date.today.month, year: Date.today.year).first
		if attr.nil?
			"0hs"
		else
			"#{attr.worked_hours}hs"
		end
	end

	def extra_hours_worked_in_month
		attr =attendance_resumes.where(month: Date.today.month, year: Date.today.year).first
		if attr.nil?
			"0hs"
		else
			"#{attr.extra_hours}hs"
		end
	end

	def cumpliment_in_month
		attr =attendance_resumes.where(month: Date.today.month, year: Date.today.year).first
		if attr.nil?
			"0hs"
		else
			"#{attr.cumpliment.round(2)}%"
		end
	end

	def dni
	  "#{document_type}: #{user.document_number}"
	end

	def state
		if user.approved
			text = "Aprobado"
			span = "success"
		elsif user.invitation_accepted_at.blank? && !user.invitation_sent_at.blank?
			text = "Invitación enviada"
			span = "primary"
		elsif user.invitation_accepted_at.blank? && uuser.invitation_sent_at.blank?
			text = "Falta aprobar"
			span = "warning"
		end
		html = <<-HTML
		<div class="text-center">
			<span class='badge-#{span} badge'>#{text}</span>
		</div>
		HTML
		return html.html_safe
	end

	def action_links
		content_tag :div do
			concat(link_to_show profile_user_path(user.id))
			concat(link_to_edit edit_user_path(user.id))
		end
	end

end
