class Tenders::FilePresenter < SaleApplicationPresenter
	presents :file
	delegate_missing_to :file

	def action_links
		content_tag :div do
			concat(link_to_show polymorphic_path(file))
			concat(link_to_edit polymorphic_path([:edit, file]), {id: "edit_file", data:{target: "#edit_file_modal", toggle: "modal", form: true}})
			concat(link_to_destroy(polymorphic_path(file)))
		end
	end

	def title
		link_to file.title, file, class: 'border-animated font-weight-bold'
	end

	def sellers
		file.budgets.map do |budget|
			budget.seller.name if budget.seller
		end.join(", ")
	end

	def responsable
		if file.user
			link_to file.user do
				concat(image_tag(file.user.avatar, class: 'rounded-circle table-avatar'))
				concat(file.user.name)
			end
		end
	end

	def delivery_dates
		file.budgets.where(state: "Aprobado").map do |budget|
			link_to budget.delivery_date, [:edit, budget]
		end.join(", ").html_safe
	end

	def delivery_data
		"En: #{file.place} - Fecha: #{file.delivery_date} #{handle_time(file.delivery_hour)}"
	end

	def delivery_addresses
		file.place
	end

	def created_at
		handle_date(file.created_at)
	end

	def init_date
		handle_date_long(file.init_date)
	end

	def finish_date
		handle_date_long(file.finish_date)
	end

	def pacient_with_number
		"#{pacient} Nº#{pacient_number}"
	end

	def open
		file.open ? "Si" : "No"
	end

	def state
		# case file.state
		# when "ENTREGADO"
		# 	color = 'success'
		# when "PENDIENTE DE STICKER"
		# 	color = 'info'
		# when "PENDIENTE DE O.C"
		# 	color = 'info'
		# when "PENDIENTE DE DOCUMENTACION CLÍNICA"
		# 	color = 'info'
		# when "COORDINAR FECHA DE CX"
		# 	color = 'primary'
		# when "LISTO PARA ENTREGA"
		# 	color = 'primary'
		# when "PERDIDO"
		# 	color = 'danger'
		# when "CANCELADO"
		# 	color = 'dark'
		# when nil
		# 	color = 'secondary'
		# else
		# 	color = 'info'
		# end
		# super(color, file.substate)
		file.state
	end

	def substate
		state
	end

	def user_name
		if !file.user.nil?
			link_to file.user.name, file.user
		end
	end

	def province
		file.custom_attributes["province"]
	end

	def current_location
		if file.file_movements.any?
			file.departments.last.name
		else
			return "Sin especificar"
		end
	end

	def implant
		link_to file.implant_original_filename, file.implant_certificate unless file.implant_certificate == "/images/attachment.png"
	end

	def surgical_sheet
		link_to file.surgical_sheet_original_filename, file.surgical_sheet unless file.surgical_sheet == "/images/attachment.png"
	end

	def note
		link_to file.note_original_filename, file.note unless file.note == "/images/attachment.png"
	end

	def sticker
		link_to file.sticker_original_filename, file.sticker unless file.sticker == "/images/attachment.png"
	end

end
