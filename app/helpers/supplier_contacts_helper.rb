module SupplierContactsHelper

	def see_contact_dl(text, value, first_col = nil)
		first_col ||= 2
		last_col = 12 - first_col
		html = <<-HTML
			<div class='d-flex'>
				<dt class='mx-3 flex-grow-1'>#{text}</dt>
				<dd class='mx-3 text-right' style='white-space: normal'>#{value}</dd>
			</div>
		HTML
	   return html.html_safe
	end
end
