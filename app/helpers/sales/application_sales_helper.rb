module Sales::ApplicationSalesHelper

	def sale_state_button(builder, opts={})
		opts[:with_button] ||= true
		record = builder.object
		if current_user.can?(:approve, record) && record.editable?
			button = button_tag "#{icon('fas', 'sync-alt')} Actualizar detalles".html_safe, id: "sync_state", type: :submit, class: 'btn btn-info', data: {disable_with: "Espere...", confirm: "Esto cambiara el estado de todos los detalles asociados al documento. ¿Está seguro que desea continuar?"}
			concat(builder.label :state, class: 'h6')
			content_tag(:div, class: 'd-flex') do
				concat(builder.input :state, label: false, collection: record.class::STATES, input_html: {id: "current_state"}, prompt: "Seleccione...", wrapper_html: {class: 'w-100'})
				concat(content_tag :div, button, class: 'mb-3 flex-shrink-1' ) if opts[:with_button]
			end
		else
			builder.input :state, label_html: {class: 'h6'}, disabled: true
		end
	end

	def sale_client_select(builder)
		content_tag :span, tabindex: 0, data: {toggle: 'tooltip', placement: "right"}, title: "Seleccione el expediente para cambiar" do
			builder.association :client, collection: current_company.clients, prompt: "Seleccione expediente...", selected: builder.object.entity_id || builder.object.file.try(:entity_id), disabled: true, prompt: false
		end
	end

	def sale_mail_modal jfunction, object
		html = <<-HTML
		<div class="modal-body">
		  	Datos del cliente
		  	<br>
		  	<br>
		  	<div class="form-group row">
		    	#{label_tag :name, "Cliente", class: 'col-sm-3 col-form-label col-form-label-sm'}
		    	<div class="col-md-8">
		      	#{text_field_tag :client_name_modal, object.client.try(:name) , class: 'form-control form-control-sm', autocomplete: false, disabled: true }
		    	</div>
		  	</div>

		  	<div class="form-group row">
		    	#{label_tag :email, "Email", class: 'col-sm-3 col-form-label col-form-label-sm'}
		    	<div class="col-md-8">
		     		#{text_field_tag :email, object.client.try(:emails), class: 'form-control form-control-sm', id: "send_email_tag"}
		    	</div>
		  	</div>
		  <br>

		</div>

		<div class="modal-footer">
		  	#{button_tag "#{icon('fas', 'arrow-circle-right')} Enviar".html_safe, class: 'btn btn-primary',type:'button', onclick: "#{jfunction}", data: {disable_with: "#{icon('fas', 'sync')} Enviando..."}}
		  	#{close_button}
		</div>
		HTML
		return html.html_safe
	end

	def document_footer(f, save_button_presence=true, extra_class='', can_add=true)
		object = f.object
		unless object.disabled?
			content_tag :center do
				concat(f.link_to_add "#{icon('fas', 'plus')} Añadir detalle".html_safe, :details, class: "btn #{extra_class} btn-success #{'disabled' if object.disabled?}", data: {target: "table.parent-table"}) if can_add
				concat( content_tag :hr, save_button) if save_button_presence
			end
		end
	end

end
