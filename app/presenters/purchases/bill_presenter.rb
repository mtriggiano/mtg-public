class Purchases::BillPresenter < PurchaseApplicationPresenter
  	presents :bill

    def cbte_tipo
      bill.cbte_short_name
    end

    def cbte_num
      content_tag :strong do
        link_to bill.number, edit_purchases_bill_path(bill.id)
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

    def gross_amount
      "$ #{bill.gross_amount.round(2)}"
    end

    def iva_amount
      "$ #{bill.iva_amount.round(2)}"
    end

    def action_links
      content_tag :div do
        concat(link_to_edit [:edit, @object])
        concat(link_to_destroy @object)
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

    def paid
      if bill.real_total_left <= 0.01
        handle_state('success', 'Pagado')
      else
        handle_state('danger', 'No pagado')
      end
    end

end
