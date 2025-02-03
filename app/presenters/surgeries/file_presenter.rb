class Surgeries::FilePresenter < Sales::FilePresenter
	presents :file


	def surgery_end_date
		handle_date_long(file.surgery_end_date)
	end

	def implant
		link_to file.implant_original_filename, file.implant_certificate unless file.implant_certificate == "/images/attachent.png"
	end

	def surgical_sheet
		link_to file.surgical_sheet_original_filename, file.surgical_sheet unless file.surgical_sheet == "/images/attachent.png"
	end

	def action_links
		content_tag :div do
			concat(link_to_show file)
			concat(link_to_edit [:edit, file], {id: "edit_file", data:{target: "#edit_file_modal", toggle: "modal", form: true}})
			concat(link_to_destroy file)
		end
	end
end
