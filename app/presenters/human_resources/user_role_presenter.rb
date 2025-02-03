class UserRolePresenter < BasePresenter
	#presents :role
	presents :user_role
	delegate :user, to: :user_role
	delegate :role, to: :user_role
	delegate :id, to: :user_role

	def role_name
		unless role.nil?
			role.friendly_name
		else
			"Sin nombre"
		end
	end

	def action_links
		content_tag :div do
			concat(link_to_edit edit_user_user_role_path(user.id, user_role.id), {id: "edit_role", data:{target: "#edit_role_modal", toggle: "modal", form: true}})
			concat(link_to_destroy(user_user_role_path(user.id, user_role.id)))
		end
	end

end
