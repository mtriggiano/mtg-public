class SaleApplicationPresenter < BasePresenter
	def id
		@object.id
	end

	def number
		unless @object.number.nil?
			link_to @object.number, [:edit, @object], class: 'border-animated font-weight-bold'
		else
			"Sin especificar"
		end
	end

	def file
		if @object.file.nil?
  			"Expediente Eliminado"
  		else
			link_to @object.file.full_name, sales_file_path(@object.file_id)
		end
	end

	def client
		unless @object.client.nil?
			link_to @object.client.name, client_path(@object.entity_id)
		else
			"Sin especificar"
		end
	end

	def total
		content_tag :div, class: "text-right" do
			number_to_ars @object.total
		end
	end

	def date
		I18n.l(@object.date, format: :short)
	end

	def debits
		content_tag :div, class: "text-right" do
			number_to_ars @object.debit_notes.sum(:total)
		end
	end

	def credits
		content_tag :div, class: "text-right" do
			number_to_ars @object.credit_notes.sum(:total)
		end
	end

	def total_paid
		content_tag :div, class: "text-right" do
			number_to_ars @object.total_pay
		end
	end

	def external_number
		handle_none(@object.external_number)
	end

	def external_purchase_order_number
		handle_none(@object.external_purchase_order_number)
	end

	def external_shipment_number
		handle_none(@object.external_shipment_number)
	end


	def action_links
		content_tag :div do
			concat(link_to_pdf [@object, {format: :pdf}]) if @object.respond_to?(:imprimible?) && @object.imprimible?
			concat(link_to_edit [:edit, @object])
			concat(link_to_destroy @object)
		end
	end
end
