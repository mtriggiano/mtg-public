class ClientContactPresenter < BasePresenter
	presents :client_contact
	delegate :titular, to: :client_contact
	delegate :position, to: :client_contact
	delegate :id, to: :client_contact
	def badge_span
		unless email.blank?
			html = <<-HTML
			<div class='p-1'>
				<span class='badge-light rounded p-2 small'>
					#{icon('fas', 'id-card-alt')}
					#{titular}
				</span>
			</div>
			HTML
			return html.html_safe
		end
	end

	def client_full_document
		present client_contact.client do |client_presenter|
			return client_presenter.document
		end
	end

	def client
		link_to client_contact.client.name, client_contact.client
	end

	def client_bank_name

	end

	def email_span
		unless email.blank?
			html = <<-HTML
			<div class='p-1'>
				<span class='p-1 small text-white'>
					#{icon('fas', 'envelope')}
					#{mail_to email}
				</span>
			</div>
			HTML
			return html.html_safe
		end
	end

	def phone_span
		unless phone.blank?
			html = <<-HTML
			<div class='p-1'>
				<span class='p-1 small'>
					#{icon('fas', 'phone')}
					#{phone}
				</span>
			</div>
			HTML
			return html.html_safe
		end
	end

	def mobile_phone_span
		unless mobile_phone.blank?
			html = <<-HTML
			<div class='p-1'>
				<span class='p-1 small'>
					#{icon('fas', 'mobile-alt')}
					#{mobile_phone}
				</span>
			</div>
			HTML
			return html.html_safe
		end
	end

	def titular
		client_contact.titular ? "Primario" : "Secundario"
	end

	def name
		link_to client_contact.name, polymorphic_path([client_contact.client, client_contact])
	end

	def email
		if client_contact.email.blank?
			"Sin especificar"
		else
			mail_to client_contact.email
		end
	end

	def phone
		handle_none(client_contact.phone)
	end

	def mobile_phone
		handle_none(client_contact.mobile_phone)
	end

	def created_at
		I18n.l(client_contact.created_at)
	end

	def action_links
		content_tag :div do
			concat(
				link_to_show(
					client_client_contact_path( client_contact.client, client_contact )
				)
			)
			concat(
				link_to_edit(
					edit_client_client_contact_path( client_contact.client, client_contact ), data: {toggle: 'modal', target: '#edit_contact_modal', form: true}
				)
			)
			concat(
				link_to_destroy(
					client_client_contact_path( client_contact.client, client_contact), data: {confirm: "Esta acción eliminara todos los registros de contacto. ¿Desea continuar?"}
				)
			)
		end
	end
end
