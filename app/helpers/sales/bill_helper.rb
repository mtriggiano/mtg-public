module Sales::BillHelper

	def switch_bill_state_button bill
		case bill.state
		when "Pendiente"
			title = "#{icon('fas', "check-square")} Confirmar"
			new_state = "Confirmado"
			if bill.manual == "E"
				bill_button = button_tag(title.html_safe, data: {target: '#edit_bill', toggle: 'modal'}, type: 'button', class: "btn mx-1 btn-success")
			else
				bill_button = button_tag(title.html_safe, type: 'submit', class: "btn mx-1 btn-success", id:'confirm_invoice_button',  data: {disable_with: "#{icon('fas', 'sync')} Cargando...", state: "#{new_state}"})
			end
			cbte_tipo = bill.cbte_tipo
		when "Confirmado"
			title = "#{icon('fas', "times")} Anular"
			new_state = "Anulado"
			if bill.manual == "E"
				bill_button = button_tag(title.html_safe, data: {target: '#edit_bill', toggle: 'modal'}, type: 'button', class: "btn mx-1 btn-danger")
			else
				bill_button = button_tag(title.html_safe, type: 'submit', class: "btn mx-1 btn-danger", id:'confirm_invoice_button',  data: {disable_with: "#{icon('fas', 'sync')} Cargando...", state: "#{new_state}"})
			end
			cbte_tipo = bill.cbte_tipo
		end

		return content_tag :div do
			concat( bill_button ) if bill_button && bill.persisted?
			concat( modal(title, "edit_bill", "edit_bill_body", "big"){ bill_state_modal(bill, new_state).html_safe } ) if bill.persisted?
		end
	end

	def bill_state_modal bill, new_state
		if new_state == "Anulado"
			modal_de_anulacion(bill, new_state)
		else
			modal_de_confirmacion(bill, new_state)
		end
	end

	def modal_de_confirmacion bill, new_state
		<<-HTML
		<div class="modal-body">
			<p class="h4 my-3">¿Desea confirmar este comprobante?</p>
			<p class="alert alert-success">
				#{icon('fas', 'exclamation-circle')} El comprobante será confirmado ante AFIP
			</p>
			<div class="row my-5">
				<div class="form-group col-4">
					#{label_tag :type, "Tipo"}
					<h4>#{Afip::CBTE_TIPO[bill.cbte_tipo]}</h4>
				</div>
				<div class="form-group col-4">
					#{label_tag :client, "Cliente"}
					<h4>#{bill.client.try(:name)} - #{bill.client.try(:full_document)}</h4>
				</div>
				<div class="form-group col-4">
					#{label_tag :total, "TOTAL"}
					<h4 id="modal_total">#{number_to_ars bill.total}</h4>
				</div>
			</div>
		</div>

		<div class="modal-footer">
				#{button_tag "#{icon('fas', 'arrow-circle-right')} Confirmar".html_safe, id:'confirm_invoice_button', class: 'btn btn-success',type:'submit',  data: {disable_with: "#{icon('fas', 'sync')} Cargando...", state: "#{new_state}"}}
		</div>
		HTML
	end

	def modal_de_anulacion bill, new_state
		<<-HTML
		<div class="modal-body">
			<p class="h4 my-3">¿Desea anular este comprobante?</p>
			<p class="alert alert-info">
				#{icon('fas', 'exclamation-circle')} La anulación del comprobante se realizará mediante una Nota de Crédito, confirmada automáticamente.
			</p>
			<div class="row my-5">
				<div class="form-group col-4">
					#{label_tag :type, "Comprobante"}
					<h4>#{bill.name(:short)}</h4>
				</div>
				<div class="form-group col-4">
					#{label_tag :client, "Cliente"}
					<h4>#{bill.client.try(:name)} - #{bill.client.try(:full_document)}</h4>
				</div>
				<div class="form-group col-4">
					#{label_tag :total, "TOTAL"}
					<h4>#{number_to_ars bill.total}</h4>
				</div>
			</div>
		</div>

		<div class="modal-footer">
			#{button_tag "#{icon('fas', 'arrow-circle-right')} Anular".html_safe, id:'confirm_invoice_button', class: 'btn btn-danger',type:'submit',  data: {disable_with: "#{icon('fas', 'sync')} Cargando...", state: "#{new_state}"}}
		</div>
		HTML
	end
end
