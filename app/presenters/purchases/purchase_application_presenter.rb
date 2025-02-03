class PurchaseApplicationPresenter < BasePresenter

	def id
		@object.id
	end

	def supplier
		link_to @object.supplier.name, supplier_path(@object.entity_id)
	end

	def number
		unless @object.number.nil?
			link_to @object.number, [:edit, @object]
		else
			"Sin especificar"
		end
	end

  	def file
  		if @object.file.nil?
  			"Expediente Eliminado"
  		else
  			link_to @object.file.full_name, purchases_file_path(@object.file_id)
  		end
  	end

  	def client
		link_to @object.client_name, client_path(@object.client_id)
	end

	def total
		content_tag :div, class: "text-right" do
			number_to_ars @object.total
		end
	end

	def date
		I18n.l(@object.date, format: :short)
	end

	def due_date
		I18n.l(@object.due_date, format: :short)
	end

	def action_links
		content_tag :div do
			concat(link_to_pdf [@object, {format: :pdf}]) if @object.respond_to?(:imprimible?) && @object.imprimible?
			concat(link_to_edit [:edit, @object])
			concat(link_to_destroy @object)
		end
	end
end
