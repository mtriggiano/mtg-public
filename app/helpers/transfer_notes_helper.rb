module TransferNotesHelper

	def change_state_button(transfer)
		unless transfer.new_record?
			case transfer.state
			when "Pendiente"
				<<-HTML
					#{link_to "#{icon('fas', 'arrow-circle-left')} Enviar".html_safe, transfer_note_path(transfer.id, transfer_note:{state: "Enviado" }), method: :patch, class: 'mx-2 btn btn-info'}
					#{link_to "#{icon('fas', 'trash')} Anular".html_safe, transfer_note_path(transfer.id, transfer_note:{state: "Anulado" }), method: :patch, class: 'mx-2 btn btn-danger'}
				HTML
			when "Enviado"
				<<-HTML
					#{link_to "#{icon('fas', 'arrow-circle-right')} Registrar recepción".html_safe, transfer_note_path(transfer.id, transfer_note:{state: "Recibido" }), method: :patch, class: 'mx-2 btn btn-success'}
					#{link_to "#{icon('fas', 'trash')} Anular".html_safe, transfer_note_path(transfer.id, transfer_note:{state: "Anulado" }), method: :patch, class: 'mx-2 btn btn-danger'}
				HTML
			end
		end
	end
end
