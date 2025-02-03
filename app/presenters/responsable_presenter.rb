class ResponsablePresenter < BasePresenter
	presents :responsable
	delegate :id, to: :responsable
	delegate :observation, to: :responsable

	def file_type
		unless responsable.file.nil?
			if responsable.file.type == "Purchases::File"
				"Compras"
			elsif responsable.file.type == "Sales::File"
				"Ventas"
			else
				"Cirugía"
			end
		else
			"N/A"
		end
	end

	def user
	  link_to responsable.user.name, responsable.user
	end

	def file
	 	link_to responsable.file.number, responsable.file
	end

	def document_type
		responsable.document
	end

	def file_number
		unless responsable.file.nil?
			if responsable.file.type == "Purchases::File"
				link_to "Nº #{responsable.file.number}", purchases_file_path(responsable.file_id)
			elsif responsable.file.type == "Sales::File"
				link_to "Nº #{responsable.file.number}", sales_file_path(responsable.file_id)
			else
				link_to "Nº #{responsable.file.number}", surgeries_file_path(responsable.file_id)
			end
		else
			"N/A"
		end
	end

	def created_at
		I18n.l(responsable.created_at, format: :short)
	end

	def action_links
		unless responsable.file.nil?
			if responsable.file.type == "Sales::File"
				content_tag :div do
					concat(link_to_show sales_file_path(responsable.file_id))
				end
			elsif responsable.file.type == "Purchases::File"
				content_tag :div do
					concat(link_to_show purchases_file_path(responsable.file_id))
				end
			else
				content_tag :div do
					concat(link_to_show surgeries_file_path(responsable.file_id))
				end
			end
		end
	end

end
