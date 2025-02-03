class StorePresenter < BasePresenter
  presents :store
  delegate_missing_to :store

  def action_links
		content_tag :div do
			concat(link_to_show store_path(store))
      concat(link_to_edit edit_store_path(store), {id: "edit_store", data:{target: "#edit_store_modal", toggle: "modal", form: true}})

		end
	end
end
