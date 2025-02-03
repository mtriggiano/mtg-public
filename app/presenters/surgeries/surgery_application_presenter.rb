class SurgeryApplicationPresenter < BasePresenter
	def id
		@object.id
	end

	def number
		unless @object.number.blank?
			link_to @object.number, [:edit, @object], class: 'border-animated font-weight-bold'
		else
			"Sin especificar"
		end
	end

  	def supplier
  		link_to @object.supplier.name, [:edit, @object.supplier]
  	end

  	def file
  		if @object.file.nil?
  			"Expediente Eliminado"
  		else
  			link_to @object.file.full_name, surgeries_file_path(@object.file_id)
  		end
  	end

  	def client
			unless @object.entity.nil?
				link_to @object.entity.name, client_path(@object.entity_id)
			else
				"Sin especificar"
			end
		end

	def total
		"$#{@object.total.round(2)}"
	end

	def date
		I18n.l(@object.date, format: :short)
	end

	def pacient
		@object.pacient
	end

	def action_links
		content_tag :div do
			concat(link_to_pdf [@object, {format: :pdf}]) if @object.respond_to?(:imprimible?) && @object.imprimible?
			concat(link_to_edit [:edit, @object])
			concat(link_to_destroy @object)
		end
	end
end
