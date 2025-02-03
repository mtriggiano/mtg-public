class Reports::PurchasePresenter < BasePresenter
	presents :bill
	delegate_missing_to :bill

	def zone
		bill.dig(:entity, :province, :name)
	end


	def cbte_tipo
		unless bill.entity.nil?
			link_to bill.cbte_short_name, [:edit, bill]
		else
			bill.cbte_short_name
		end
  end

  	def emision
    	I18n.l(bill.cbte_fch)
  	end

	def number
		unless bill.entity.nil?
			link_to bill.number, [:edit, bill]
		else
			bill.number
		end
	end

	def sale_point
		bill.sale_point.rjust(4, '0') unless bill.sale_point.nil?
	end

	def total
		bill.total
	end

	def total_pay
		bill.total_pay
	end

	def total_left
		bill.total_left
	end

	def orders
		bill.expedient_orders.map do |order|
      link_to order.number, [:edit, order]
    end.join(", ").html_safe
	end

	def cancelation
		bill.cancelation_date
	end

	def supplier
		unless bill.entity.nil?
			entity_name = bill.entity.try(:denomination) || bill.entity.try(:name)
			link_to entity_name, polymorphic_path(bill.entity)
		else
			"Sin especificar"
		end
	end

	def state
		case bill.state
		when "Aprobado"
			span = 'success'
		when "Anulado"
			span = 'danger'
		end
		super(span, bill.state)
	end

	def action_links
	end
end
