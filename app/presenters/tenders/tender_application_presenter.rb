class TenderApplicationPresenter < BasePresenter

	def id
		@object.id
	end

	def number
		unless @object.number.nil?
			link_to @object.number, [:edit, @object]
		else
			"Sin especificar"
		end
	end

  	def file
  		link_to "#{@object.file.number} - #{@object.file.title}", tenders_file_path(@object.file_id)
  	end

  	def client
		link_to @object.client.name, client_path(@object.entity_id)
	end

	def total
		"$#{@object.total.round(2)}"
	end

	def date
		I18n.l(@object.date, format: :short)
	end

	def action_links
		content_tag :div do
			concat(link_to_pdf [@object, {format: :pdf}])
			concat(link_to_edit [:edit, @object])
			concat(link_to_destroy @object)
		end
	end
end
