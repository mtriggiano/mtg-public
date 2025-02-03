class ClientPresenter < BasePresenter
	presents :client
	delegate :id, to: :client
	delegate :denomination, to: :client

	def name
		link_to client.name, client, class: 'border-animated font-weight-bold'
	end

	def document
		"#{document_type_name}: #{client.document_number}"
	end

	def document_type_name
	  Afip::DOCUMENTOS.key(client.document_type)
	end

	def iva_cond
		client.iva_cond
	end

	def address
		handle_none(client.address)
	end

	def current_balance
		color =  client.current_balance < 0 ? 'danger' : 'success'
		content_tag :div, class: "text-right text-#{color}" do
			number_to_ars client.current_balance
		end
	end

	def recharge
		"#{client.recharge.round(2)} %"
	end

	def action_links
		content_tag :div do
			concat( link_to icon('fas', 'search-dollar'), debt_client_path(client.id), class:'btn btn-icon btn-sm btn-light btn-outline-secondary')
			concat(link_to_show client_path(client.id))
			concat(link_to_edit edit_client_path(client.id), {id: "edit_client", data:{target: "#edit_client_modal", toggle: "modal", form: true}})
			concat(link_to_destroy(client_path(client.id)))
		end
	end

end
