class SupplierContactPresenter < BasePresenter
	presents :supplier_contact
	delegate :titular, to: :supplier_contact
	delegate :position, to: :supplier_contact
	delegate :id, to: :supplier_contact
	def badge_span
		unless email.blank?
			html = <<-HTML
			<div class='p-1'>
				<span class='badge-info rounded p-2 small'>
					#{icon('fas', 'id-card-alt')}
					#{titular}
				</span>
			</div>
			HTML
			return html.html_safe
		end
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
		supplier_contact.titular ? "Primario" : "Secundario"
	end

	def name
		link_to "#{supplier_contact.name}".html_safe, supplier_supplier_contact_path(supplier_contact.entity_id, supplier_contact.id)
	end

	def email
		if supplier_contact.email.blank?
			"Sin especificar"
		else
			mail_to supplier_contact.email
		end
	end

	def phone
		handle_none(supplier_contact.phone)
	end

	def mobile_phone
		handle_none(supplier_contact.mobile_phone)
	end

	def created_at
		I18n.l(supplier_contact.created_at)
	end


	def action_links
		content_tag :div do
			concat(
				link_to_show(
					supplier_supplier_contact_path( supplier_contact.entity_id, supplier_contact.id )
				)
			)
			concat(
				link_to_edit(
					edit_supplier_supplier_contact_path( supplier_contact.entity_id, supplier_contact.id ), data: {toggle: 'modal', target: '#edit_contact_modal', form: true}
				)
			)
			concat(
				link_to_destroy(
					supplier_supplier_contact_path( supplier_contact.entity_id, supplier_contact.id ), data: {confirm: "Esta acción eliminara todos los registros de contacto. ¿Desea continuar?"}
				)
			)
		end
	end
end
