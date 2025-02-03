module Purchases::PurchaseOrdersHelper

	def send_to_supplier_button(record)
		if record.persisted? && record.errors.empty?
			content_for(:extra_links) do
				content_tag :li, class: 'nav-item' do
					concat(button_tag "#{icon('fas', 'envelope')} Enviar".html_safe, type: 'button', data: {target: '#send_budget', toggle: 'modal'}, class: 'btn border-0 bg-white')
				end
			end

			html = purchase_mail_modal("sendBudgetPDF('#{record.id}', '#{record.class.name.snakecase.pluralize}')", record)

			return modal("#{icon('fas', 'envelope')} Enviar".html_safe, "send_budget", "send_budget_body"){ html.html_safe }
		end
	end
end
