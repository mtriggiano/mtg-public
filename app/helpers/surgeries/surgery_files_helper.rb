module Surgeries::SurgeryFilesHelper
  def surgery_header f
		file_header f do
	  		concat(link_to "#{icon('fas', 'briefcase-medical')} Ver datos de cirugía".html_safe, "javascript:void(0)", data: {target: '#file_data', toggle: 'modal', form: false})
			concat(surgery_file_pacient_modal(f.object.file))
	      	concat(hidden_field_tag "hidden_iva", "03")
		end
  end

  	def surgery_file_pacient_modal(surgery_file=nil)
  		modal("#{icon('fas', 'briefcase-medical')} Datos de cirugía", "file_data", "modal-body", "big") do
  			if surgery_file
  				concat(surgery_file_pacient_data(surgery_file))
  			end
  		end
  	end

  	def surgery_file_pacient_data(surgery_file)
		surgery_file_presenter = present surgery_file
		content_tag :div, class: 'modal-body' do
			concat(see_contact_dl("Obra social", surgery_file_presenter.client))
			concat(tag :hr, class: 'dotted')
			concat(see_contact_dl("Médico", surgery_file.doctor))
			concat(tag :hr, class: 'dotted')
			concat(see_contact_dl("Afiliado", surgery_file_presenter.pacient_with_number))
			concat(tag :hr, class: 'dotted')
			concat(see_contact_dl("Provincia", surgery_file_presenter.province))
			concat(tag :hr, class: 'dotted')
			concat(see_contact_dl("Lugar", surgery_file.place))
			concat(tag :hr, class: 'dotted')
			concat(see_contact_dl("Fecha de inicio", surgery_file_presenter.init_date))
			concat(tag :hr, class: 'dotted')
			concat(see_contact_dl("Fecha de cirugía", surgery_file_presenter.finish_date))
			concat(tag :hr)
			concat(close_button)
		end
  	end
end
