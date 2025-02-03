class BillMovementPresenter < BasePresenter
	presents :movement
	delegate_missing_to :movement

	def returned
		if movement.returned
			content_tag :div, icon('fas', 'check-square'), class: 'text-success'
		else
			content_tag :div, icon('far', 'square'), class: 'text-warning'
		end
	end

	def signed
		if movement.signed
			content_tag :div, icon('fas', 'check-square'), class: 'text-success'
		else
			content_tag :div, icon('far', 'square'), class: 'text-warning'
		end
	end

	def bill_name
		link_to movement.bill_name, [:edit, movement.bill], class: 'border-animated font-weight-bold'
	end

  def action_links
		link_to_edit([:edit,movement], {data: {target: '#bill_movement_modal', toggle: 'modal', form: true}})
  end
end
