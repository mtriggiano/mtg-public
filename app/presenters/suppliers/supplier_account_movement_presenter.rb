class SupplierAccountMovementPresenter < BasePresenter
	presents :movement
	delegate :id, to: :movement
	delegate :parent, to: :movement
	delegate :bill, to: :movement
	delegate :payment_order, to: :movement
	delegate :expense?, to: :movement
	delegate :income?, to: :movement
	delegate :total, to: :movement

	def cbte_tipo
		if parent == :bill
			link_to movement.cbte_tipo, edit_external_bill_path(movement.payment_bill)
		elsif payment_order
			link_to movement.cbte_tipo,  edit_purchases_payment_order_path(payment_order)
		else
			movement.cbte_tipo
		end
	end

	def income
		if income?
			content_tag :div, class: 'bold text-danger text-right' do
				number_to_ars total
			end
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

	def action_links
		content_tag :div do
			if movement.payment_bill
				concat(link_to_pdf [movement.payment_bill, {format: :pdf}]) if movement.payment_bill.has_pdf?
				concat(link_to_show [:edit, movement.payment_bill])
			elsif movement.payment_order
				concat(link_to_pdf [movement.payment_order, {format: :pdf}]) if movement.payment_order.has_pdf?
				concat(link_to_show [:edit, movement.payment_order])
			end
		end
	end

	def date
		unless movement.date.nil?
			date = I18n.l(movement.date)
		else
			date = "Sin especificar"
		end

		return movement.payment_bill.try(:cbte_fch) || movement.payment_order.try(:date) || date
	end

end
