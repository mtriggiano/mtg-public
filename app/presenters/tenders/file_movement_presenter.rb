class Tenders::FileMovementPresenter < TenderApplicationPresenter
  	presents :movement

  	def sended_by
		#TODO Cuando se cree el perfil del usuario agregar el path al final.
		link_to "#{image_tag movement.sender.avatar, class: 'img-fluid border rounded-circle table-avatar'} #{movement.sender.name}".html_safe, "#"
	end

	def received_by
		#TODO Cuando se cree el perfil del usuario agregar el path al final.
		if movement.received_by.blank?
			"Sin receptor"
		else
			link_to "#{image_tag movement.receiver.avatar, class: 'img-fluid border rounded-circle table-avatar'} #{movement.receiver.name}".html_safe, "#"
		end
	end

	def sended_at
		I18n.l(movement.sended_at, format: :long)
	end

	def department
		movement.department.try(:name)
	end

	def action_links
		content_tag :div do
			concat(link_to_show tenders_file_movement_path(movement.id, tender_file_id: movement.file_id), {data:{target: "#show_movement_modal", toggle: "modal", form: true}})
		end
	end
end
