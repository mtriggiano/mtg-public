class Surgeries::PrescriptionPresenter < Sales::SaleRequestPresenter
	presents :prescription
	delegate :file, to: :prescription

	def file
		link_to prescription.file.full_name, surgeries_file_path(prescription.file.id)
	end

	def number
		link_to prescription.number, edit_surgeries_prescription_path(prescription.id), class: 'border-animated font-weight-bold'
	end

	def action_links
		content_tag :div do
			concat(link_to_edit edit_surgeries_prescription_path(prescription.id))
			concat(link_to_destroy(surgeries_prescription_path(prescription.id)))
		end
	end
end
