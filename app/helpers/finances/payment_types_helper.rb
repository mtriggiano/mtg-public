module Finances::PaymentTypesHelper
  def imputed_in_cash_helper(payment_type)
		if payment_type.imputed_in_cash
			handle_state("success", "Si")
		else
			handle_state("danger", "No")
		end
	end

  def handle_state state, text
    content_tag :span, text, class: "badge-#{state} rounded p-2 small"
  end
end
