class ClientContactRecordPresenter < BasePresenter
	presents :contact_record
	delegate :id, to: :contact_record
	delegate :client_contact, to: :contact_record
	delegate :client, to: :client_contact

	def action_links
		content_tag :div do
			concat(link_to_show(polymorphic_path([client, client_contact, contact_record]), id: "see_contact_record", data:{target: "#see_contact_record_modal", toggle: "modal"}))
			concat(link_to_edit(edit_polymorphic_path([client, client_contact, contact_record]), id: "edit_contact_record", data:{target: "#edit_contact_record_modal", toggle: "modal", form: true}))
			concat(link_to_destroy(polymorphic_path([client, client_contact, contact_record])))
		end
	end

	def user_name
		#TODO Cuando se cree el perfil del usuario agregar el path al final.
		link_to "#{image_tag contact_record.user.avatar, class: 'img-fluid border rounded-circle table-avatar'} #{contact_record.user.name}".html_safe, "#"
	end

	def date
		handle_date(contact_record.date)
	end

	def title
		handle_none(contact_record.title)
	end

	def object
		handle_none(contact_record.object)
	end

	def body
		handle_none(contact_record.body)
	end

	def created_at
		I18n.l(contact_record.created_at)
	end
end
