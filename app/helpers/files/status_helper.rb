module Files::StatusHelper
	def state_manager builder
		record = builder.object
		return if record.new_record?
		options = record.available_states
		disable_with = "<i class=&quot;fas fa-sync&quot;></i> Cargando..."
		explanation = "Esto cambiara el estado del documento. ¿Está seguro que desea continuar?"
		unless options.empty?
			content_tag :div, class: 'row justify-content-center w-100 mt-2' do
				options.each do |option|
					if option[:can]
						concat(button_tag option[:action], type: :submit, id: :sync_state, class: "btn btn-outline-#{option[:color]} mt-3 mx-1", data: {'state' => option[:state], 'disable-with' => disable_with, 'confirm' => explanation})
					else
						concat(button_tag option[:action], type: :button, class: "btn btn-outline-#{option[:color]} mt-3 mx-1 disabled", data: {toggle: 'tooltip', title: 'No posee los permisos'})
					end
				end
			end
		end
	end


	def file_state_manager builder
		file_states = eval("#{builder.object.class.name.deconstantize}::File::STATES")
		modal("¿Desea cambiar el estado del expediente?", "file_state",  "file_state_body") do
			content_tag :div, class: 'modal-body' do
				concat( label_tag :file_state, "Estado")
				concat( select_tag :file_state, options_for_select(file_states, builder.object.dig(:file, :state)), include_blank: "Ninguno", class: 'form-control')
				concat( label_tag :file_substate, "Subestado")
				concat( select_tag :file_substate, options_for_select(Expedient::PARTIAL_SHIPMENT_SUBSTATES, builder.object.dig(:file, :substate)), include_blank: "Ninguno", class: 'form-control')
				concat( content_tag :div, save_button(nil, "file_state_submit"), class: 'modal-footer mt-3 border-top' )
			end
		end
	end
end
