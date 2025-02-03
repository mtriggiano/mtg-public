class StoreLinePresenter < BasePresenter
	presents :line

	def name
		handle_none(line.name)
	end

	def created_at
		I18n.l(line.created_at, format: :short)
	end

	def action_links
		content_tag :div do
			concat(link_to_show stores_external_store_line_path(line.id, external_id: line.store_id))
			concat(link_to_edit edit_stores_external_store_line_path(line.id, external_id: line.store_id), {id: "edit_store_line_external", data:{target: "#edit_stores_external_modal", toggle: "modal", form: true}})
			concat(link_to_destroy(stores_external_store_line_path(line.id, external_id: line.store_id)))
		end
	end

end