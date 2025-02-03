module Sales::SaleOrdersHelper
	def sale_order_type_button(builder)
		if params[:sale_file_id] && builder.object.new_record?
			selected = current_company.sale_files.find(params[:sale_file_id]).try(:sale_type)
		else
			selected = builder.object.order_type
		end
		
		if current_user.can?(:approve, builder.object) && builder.object.editable?
			button = button_tag "#{icon('fas', 'sync-alt')} Actualizar detalles".html_safe, type: 'button', onclick: "syncTypes()", class: 'btn btn-info', data: {disable_with: "Espere..."}
			concat(builder.label :order_type, "Tipo", class: 'h6')
			content_tag(:div, class: 'd-flex') do
				concat(builder.input :order_type, label: false, collection: SaleFile::TYPES, input_html: {id: "current_type"}, prompt: "Seleccione...", wrapper_html: {class: 'w-100'}, selected: selected)
				concat(content_tag :div, button, class: 'mb-3 flex-shrink-1' )
			end
		else
			builder.input :order_type, label: "Tipo", label_html: {class: 'h6'}, disabled: true
		end
	end
end
