class Surgeries::SupplierBillPresenter < SurgeryApplicationPresenter
	presents :bill

  def cbte_tipo
    Afip::CBTE_TIPO[bill.cbte_tipo]
  end

  def number
    content_tag :strong do
      link_to bill.number, polymorphic_path([:edit, bill])
    end
  end

  def gross_amount
    "$ #{bill.gross_amount.round(2)}"
  end

  def iva_amount
    "$ #{bill.iva_amount.round(2)}"
  end

  def debits
    "$#{bill.debit_notes.sum(:total)}"
  end

  def credits
    "$#{bill.credit_notes.sum(:total)}"
  end

  def total_paid
    "$#{bill.total_pay}"
  end

  def paid
    if bill.real_total_left == 0
      handle_state('success', 'Pagado')
    else
      handle_state('danger', 'No pagado')
    end
  end

	def state
		case bill.state
		when "Pendiente"
			span = 'warning'
		when "Confirmado"
			span = 'success'
		when "Anulado"
			span = 'dark'
		when "Anulado parcialmente"
			span = 'secondary'
		when "Aprobado"
			span = 'success'
		end
		super(span, bill.state)
	end

end
