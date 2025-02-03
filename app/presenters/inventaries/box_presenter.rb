class BoxPresenter < ProductPresenter

  def action_links
		content_tag :div do
			concat(link_to_show polymorphic_path(product))
			concat(link_to_edit polymorphic_path([:edit,product]))
			concat(link_to_destroy(box_path(product.id)))
		end
	end
end
