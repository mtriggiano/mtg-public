module Sales::SaleBudgetsHelper

	def send_to_client_button(sale_budget)
		if sale_budget.persisted? && sale_budget.errors.empty?
			content_for(:extra_links) do
				content_tag :li, class: 'nav-item' do
					concat(button_tag "#{icon('fas', 'envelope')} Enviar".html_safe, type: 'button', data: {target: '#send_budget', toggle: 'modal'}, class: 'btn border-0 bg-white')
				end
			end
			html = sale_mail_modal("sendBudgetPDF('#{sale_budget.id}', '#{sale_budget.class.name.snakecase.pluralize}')", sale_budget)

			return modal("#{icon('fas', 'envelope')} Enviar".html_safe, "send_budget", "send_budget_body"){ html.html_safe }
		end
	end
end
