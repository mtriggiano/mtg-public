class Reports::PaymentOrderPresenter < BasePresenter
	presents :payment_order
	delegate_missing_to :payment_order

  def number
    link_to payment_order.number, [:edit, payment_order]
  end

  def supplier
    unless payment_order.supplier.nil?
      link_to payment_order.supplier.name, payment_order.supplier
    else
      "Proveedor eliminado"
    end
  end

  def state
		case payment_order.state
		when "Aprobado"
			span = 'success'
		when "Anulado"
			span = 'danger'
		end
		super(span, payment_order.state)
	end

  def action_links

  end
end
