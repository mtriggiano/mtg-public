module Surgeries::ApplicationSurgeryHelper
	def surgery_state_button(builder)
		if current_user.can?(:approve, builder.object) && builder.object.editable?
			button = button_tag "#{icon('fas', 'sync-alt')} Actualizar detalles".html_safe, id: "sync_state", type: 'submit', class: 'btn btn-info', data: {disable_with: "Espere...", confirm: "Esto cambiara el estado de todos los detalles asociados al documento. ¿Está seguro que desea continuar?"}
			concat(builder.label :state, "Estado", class: 'h6')
			content_tag(:div, class: 'd-flex') do
				concat(builder.input :state, label: false, collection: builder.object.class::STATES, input_html: {id: "current_state"}, prompt: "Seleccione...", wrapper_html: {class: 'w-100'})
				concat(content_tag :div, button, class: 'mb-3 flex-shrink-1' )
			end
		else
			builder.input :state, label: "Estado", label_html: {class: 'h6'}, disabled: true
		end
	end

end