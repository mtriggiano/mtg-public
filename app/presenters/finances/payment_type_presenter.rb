class PaymentTypePresenter < BasePresenter
	presents :payment_type
	delegate :id, to: :payment_type
	delegate :name, to: :payment_type

	def imputed_in_cash
		if payment_type.imputed_in_cash
			handle_state("success", "Si")
		else
			handle_state("danger", "No")
		end
	end

	def action_links
		content_tag :div do
			concat(link_to_edit edit_payment_type_path(payment_type.id))
			concat(link_to_destroy payment_type)
		end
	end
end