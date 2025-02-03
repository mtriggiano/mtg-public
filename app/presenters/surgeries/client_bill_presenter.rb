class Surgeries::ClientBillPresenter < SurgeryApplicationPresenter

	presents :bill

    def cbte_tipo
      link_to bill.cbte_long_name, polymorphic_path([:edit, bill])
    end

    def comp_number
      content_tag :strong, bill.comp_number
    end

    def imp_iva
      "$#{bill.imp_iva.round(2)}"
    end

		def sellers
		  bill.budgets.map{|a| a.seller.try(:name)}.join(", ")
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
       when "Enviado"
        span = 'info'
      end
      super(span, bill.state)
    end

    def estimated_days_to_pay
      if (!bill.reception_date.blank? && !bill.estimated_days_to_pay.blank?)
        pay_date = (bill.reception_date + bill.estimated_days_to_pay.days).to_date
        calc = (pay_date > Date.today) ? pay_date - Date.today : 0
        if (calc.to_i >= 5 && calc < 10)
          span = 'warning'
        elsif calc >= 10
          span = 'success'
        elsif calc < 5
          span = 'danger'
        end
        return handle_pay_day(span, pay_date)
      else
        pay_date = nil
        return "Sin especificar fecha de pago"
      end
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
end
