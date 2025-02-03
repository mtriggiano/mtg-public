class SupplierPresenter < BasePresenter
	presents :supplier
	delegate :id, to: :supplier
	delegate :contacts, to: :supplier
	delegate :full_document, to: :supplier

	def name
		link_to supplier.name, supplier, class: 'border-animated font-weight-bold'
	end

	def denomination
		handle_none(supplier.denomination)
	end

	def contact_name
		if titular.nil? || titular.name.blank?
			"Sin especificar"
		else
			link_to "#{titular.name}".html_safe, supplier_supplier_contact_path(supplier.id, titular.id)
		end
	end

	def titular_name
		if titular.nil? || titular.name.blank?
			"Sin especificar"
		else
			titular.name
		end
	end

	def contact_phone
		titular.nil? ? "Sin especificar" : handle_none(titular.phone)
	end

	def contact_email
		if titular.nil?
			"Sin especificar"
		elsif titular.email.blank?
			"Sin especificar"
		else
			mail_to titular.email
		end
	end

	def current_balance
		balance = supplier.current_balance.round(2)
		if balance < 0
			handle_state 'success', number_to_ars(balance)
		elsif balance == 0
			handle_state 'info', number_to_ars(balance)
		else
			handle_state 'danger', number_to_ars(balance)
		end
	end

	def action_links
		content_tag :div do
			concat(link_to_show(supplier))
			concat(link_to_edit(edit_supplier_path(supplier.id), data: {toggle: 'modal', target: '#edit_supplier_modal', form: true}))
			concat(link_to_destroy(supplier))
		end
	end

	def titular
		contacts.first
  	end

  	def address
  		handle_none(supplier.address)
  	end

  	def cbu
  		handle_none(supplier.cbu)
  	end

  	def account
  		handle_none(supplier.account)
  	end

  	def bank
  		handle_none(supplier.bank)
  	end

  	def supplier_presenter
  		handle_none(supplier.iva_cond)
  	end

	def document_number
		handle_none(supplier.document_number)
	end

  	def created_at
  		I18n.l(supplier.created_at)
  	end

  	def email
  		if email.blank?
  			"Sin especificar"
  		else
  			mail_to email
  		end
  	end

end
