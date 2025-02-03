class AccountMovementPresenter < BasePresenter
	presents :movement
	delegate :id, to: :movement
	delegate :flow, to: :movement
	delegate :parent, to: :movement
	delegate :total, to: :movement
	delegate :bill, to: :movement
	delegate :expense?, to: :movement
	delegate :income?, to: :movement
	delegate :receipt, to: :movement

	def cbte_tipo
		GeneralBill.unscoped do
			if parent == :bill
				if bill.type == "Sales::Bill"
					link_to movement.cbte_tipo, edit_sales_bill_path(bill.id)
				elsif bill.type == "Surgeries::ClientBill"
					link_to movement.cbte_tipo, edit_surgeries_client_bill_path(bill.id)
				end
			else
				link_to movement.cbte_tipo, edit_expedient_receipt_path(receipt.id)
			end
		end
	end

	def income
		content_tag :div, class: 'bold text-danger text-right' do
			number_to_ars total if income?
		end
	end

	def expense
		if expense?
			if total > 0
				content_tag :div, class: 'bold text-success text-right' do
					number_to_ars total
				end
			else
				content_tag :div, class: 'bold text-danger text-right' do
					number_to_ars total
				end
			end
		end
	end

	def balance
		content_tag :div, class: 'bold text-right' do
			number_to_ars movement.balance
		end
	end

	def date
		unless movement.date.nil?
			I18n.l(movement.date)
		else
			"Sin especificar"
		end
	end

end
