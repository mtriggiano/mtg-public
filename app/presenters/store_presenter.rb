class StorePresenter < BasePresenter
	presents :store

	def name
		handle_none(store.name)
	end

	def location
		handle_none(store.location)
	end

	def filled
		if store.filled
			badge("No", "success")
		else
			badge("Si", "danger")
		end
	end

	def state
		if store.filled	
			badge("Completo", "sucess")
		else
			badge("Pendiente de reposición", "danger")
		end
	end
	
	def action_links
		if store.external?
			content_tag :div do
				concat(link_to_show stores_external_path(store.id))
				concat(link_to_edit edit_stores_external_path(store.id), {id: "edit_stores_external", data:{target: "#edit_stores_external_modal", toggle: "modal", form: true}})
				concat(link_to_destroy(stores_external_path(store.id)))
			end
		else
			content_tag :div do
				concat(link_to_show stores_local_path(store.id))
				concat(link_to_edit edit_stores_local_path(store.id), {id: "edit_stores_local", data:{target: "#edit_stores_local_modal", toggle: "modal", form: true}})
				concat(link_to_destroy(stores_local_path(store.id)))
			end
		end
	end

end