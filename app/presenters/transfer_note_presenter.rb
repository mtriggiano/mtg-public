class TransferNotePresenter < BasePresenter
	presents :transfer

	def number
		link_to transfer.number, transfer
	end

	def sended_date
		I18n.l(transfer.sended_date, format: :short)
	end

	def arrival_date
		I18n.l(transfer.arrival_date, format: :short)
	end

	def state
		case transfer.state
		when "Pendiente"
			span = 'warning'
		when "Recibido"
			span = 'info'
		when "Enviado"
			span = 'primary'
		when "Finalizado"
			state = 'success'
		when "Anulado"
			span = 'dark'
		end

		html = <<-HTML
		<span class='badge-#{span} rounded p-2 small'>#{transfer.state}</span>
		HTML
		return html.html_safe
	end

	def action_links
		content_tag :div do
			concat(link_to_show transfer_note_path(transfer.id))
			concat(link_to_edit edit_transfer_note_path(transfer.id))
			concat(link_to_destroy(transfer_note_path(transfer.id)))
		end
	end

end