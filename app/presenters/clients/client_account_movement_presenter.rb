class ClientAccountMovementPresenter < AccountMovementPresenter
	presents :movement

	def action_links
		content_tag :div, class: 'text-center' do

			case movement.bill.try(:type)
			when "Sales::Bill"
				concat(link_to_pdf sales_bill_path(movement.bill, {format: :pdf}))
				concat(link_to_show edit_sales_bill_path(movement.bill))
			when "Tenders::Bill"
				concat(link_to_pdf tenders_bill_path(movement.bill, {format: :pdf}))
				concat(link_to_show edit_tenders_bill_path(movement.bill))
			when "Surgeries::ClientBill"
				concat(link_to_pdf surgeries_client_bill_path(movement.bill, {format: :pdf}))
				concat(link_to_show edit_surgeries_client_bill_path(movement.bill))
			else
				concat(link_to_pdf polymorphic_path(movement.receipt, {format: :pdf}))
				concat(link_to_show [:edit, movement.receipt])
			end
			concat(
				link_to icon('fas', 'dollar-sign'),
					assign_bill_to_expedient_receipt_path(movement.receipt),
					class: 'btn btn-icon btn-sm btn-light btn-outline-success ml-1',
					data: {target: '#assig_bill_modal', toggle: 'modal'}
			) if movement.receipt.try(:has_available_account_payment?)
		end
	end
end
