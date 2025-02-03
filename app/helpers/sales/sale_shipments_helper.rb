module Sales::SaleShipmentsHelper
	def switch_shipment_state_button shipment
		if shipment.persisted?
			case shipment.state
			when "Pendiente"
				title = "#{icon('fas', "check-square")} Confirmar"
				new_state = "Confirmado"
				if current_user.can?(:approve, shipment)
					shipment_button = button_tag(title.html_safe, data: {target: '#edit_shipment', toggle: 'modal'}, type: 'button', class: "btn mx-1 btn-success")
				else
					shipment_button = button_tag(title.html_safe, data: {toggle: 'tooltip', title: 'No posee permisos.'}, type: 'button', class: "btn mx-1 btn-success")
				end
				text = "Está por confirmar un remito"
			when "Anulado parcialmente"
				title = "#{icon('fas', "minus-square")} Anular"
				new_state = "Anulado"
				if current_user.can?(:approve, shipment)
					shipment_button = button_tag(title.html_safe, data: {target: '#edit_shipment', toggle: 'modal'}, type: 'button', class: "btn mx-1 btn-danger")
				else
					shipment_button = button_tag(title.html_safe, data: {toggle: 'tooltip', title: 'No posee permisos.'}, type: 'button', class: "btn mx-1 btn-danger")
				end
				text = "Está a punto de generar una anulación al remito Nº #{shipment.number}"
			when "Confirmado"
				title = "#{icon('fas', "minus-square")} Anular"
				new_state = "Anulado"
				text = "Está a punto de generar una anulación al remito Nº #{shipment.number}"
				if current_user.can?(:approve, shipment)
					shipment_button = button_tag(title.html_safe, data: {target: '#edit_shipment', toggle: 'modal'}, type: 'button', class: "btn mx-1 btn-danger")
				else
					shipment_button = button_tag(title.html_safe, data: {toggle: 'tooltip', title: 'No posee permisos.'}, type: 'button', class: "btn mx-1 btn-danger")
				end
			end

			html = <<-HTML
				<div class="modal-body">
				  #{text}. ¿Está seguro que desea continuar?
				  </br>
				  </br>
				  <div class="form-group row">
				    	#{label_tag :name, "Cliente", class: 'col-sm-3 col-form-label col-form-label-sm'}
				    <div class="col-md-8">
				      #{text_field_tag :client_name_modal, shipment.client.name , class: 'form-control form-control-sm', autocomplete: false, disabled: true }
				    </div>
				  </div>

				  <div class="form-group row">
				    #{label_tag :number, "Número", class: 'col-sm-3 col-form-label col-form-label-sm'}
				    <div class="col-md-8">
				      #{text_field_tag :shipment_number_modal, shipment.number , class: 'form-control form-control-sm', autocomplete: false, disabled: true}
				    </div>
				  </div>

				  <div class="form-group row">
				    #{label_tag :date, "Fecha", class: 'col-sm-3 col-form-label col-form-label-sm'}
				    <div class="col-md-8">
				      #{text_field_tag :shipment_date_modal, I18n.l(shipment.date, format: :short) , class: 'form-control form-control-sm', autocomplete: false, disabled: true}
				    </div>
				  </div>

				  </br>


				</div>

				<div class="modal-footer">
				  	#{button_tag "#{icon('fas', 'arrow-circle-right')} Seguir".html_safe, id:'confirm_shippment_button', onclick: "setShipmentState('#{new_state}')", class: 'btn btn-primary', type:'button',  data: {disable_with: "#{icon('fas', 'sync')} Cargando..."}}
				  	#{close_button}
				</div>
				HTML

			#html_send = sale_mail_modal("sendShipmentPDF('#{shipment.id}')", shipment)

			return content_tag :div do
				concat( shipment_button ) if shipment.persisted?
				concat( modal(title, "edit_shipment", "edit_shipment_body", "big"){ html.html_safe } )
				#concat( modal("#{icon('fas', 'envelope')} Enviar comprobante".html_safe, "send_shipment", "send_shipment_body"){ html_send.html_safe } )
			end
		end
	end

	def shipment_batch_td builder
		if builder.object.product_id.nil?
			builder.input :batch_id, disabled: true, prompt: "Seleccione producto"
		else
			builder.association :batch,
			label_method: :code,
			value_method: :id,
			disabled: (builder.object.product.nil? || sale_shipment.disabled?),
			prompt: builder.object.batch_prompt,
			input_html: {
				data: {
					url: availables_product_batches_path(builder.object.product_id)
				}
			}
		end
	end
end
