module PaymentsManager
  # Autor: Ariel Agustín García Sobrado
  #
  # Responsabilidad: Imputar los pagos y pagar las facturas asociadas en una Orden de Pago (confirmada)
  # Fix: Actualiza los balances para cada pago.
  #
  class PaymentOrderConfirmator < PaymentsManager::PaymentService
    def initialize(payment_order)
      @payment_order = payment_order
    end

    def call
      ActiveRecord::Base.transaction do
        paga_facturas_asociadas
        imputa_pagos
      end
    end

    private

    def paga_facturas_asociadas
      @payment_order.details.includes(:bill).each do |detail|
        if detail.bill
          bill_total_left = ((detail.bill.total_left - detail.total.abs) < 0) ? 0 : (detail.bill.total_left - detail.total.abs)
    			bill_total_paid = detail.bill.total_pay + detail.total.abs
    			if detail.total.abs >= detail.bill.total_left
    				detail.bill.pay_total!
    			else
    				detail.bill.update_columns(total_pay: bill_total_paid, total_left: bill_total_left)
    			end
    		end
      end
    end

    def imputa_pagos
      compensaciones = []
      @payment_order.payments.includes([:payment_type]).each do |detail_bill|
        if imputa_en_caja?(detail_bill)
          case tipo_de_pago(detail_bill)
          when "Cheque"
            genera_cheque_emitido(detail_bill)
          when "Cheque electrónico"
            genera_cheque_emitido(detail_bill)
          else
            genera_egreso_efectivo(detail_bill)
          end
        end
        pp compensaciones << detail_bill if tipo_de_pago(detail_bill) == "Compensación"
        actualiza_balance_de_forma_de_pago(detail_bill)
      end
      generate_recibo_compensacion(compensaciones)
    end

    def genera_egreso_efectivo(detail)
      expense = @payment_order.payment_expenses.new.tap do |expense|
        expense.codigo       = codigo_comprobante
        expense.descripcion  = descripcion_de_pago
        expense.cash_account = caja_de_pago(detail)
        expense.importe      = importe_de_pago(detail)
        expense.forma        = tipo_de_pago(detail)
        expense.fecha        = Date.today
        expense.lugar        = @payment_order.supplier.name
        expense.company_id   = company_reference
        expense.user_id      = user_reference
      end
      expense.save!
    end

    def genera_cheque_emitido(detail)
      cheque = @payment_order.emitted_checks.new.tap do |check|
        check.numero              = detail.number
        check.checkbook_id        = chequera(detail)
        check.vencimiento         = fecha_de_pago(detail)
        check.importe             = importe_de_pago(detail)
        check.importe_pagado      = 0
        check.concepto            = "Pago de facturas - #{@payment_order.supplier.name}"
        check.entity_id           = entity_reference
        check.company_id          = company_reference
        check.bank_account_id     = bank_account(detail)
        check.check_type          = tipo_de_pago(detail)
      end
      cheque.save!
    end

    def actualiza_balance_de_forma_de_pago(detail)
      payment_type = detail.payment_type
      payment_type.balance -= importe_de_pago(detail)
      payment_type.save!
    end

    def generate_recibo_compensacion(compensaciones)
      unless compensaciones.blank?
        ClientManager::ReceiptCreator.new(@payment_order.user, @payment_order.name, @payment_order.date, @payment_order.company, @payment_order.supplier, compensaciones).perform
      end
    end

    def codigo_comprobante
      @payment_order.name
    end

    def descripcion_de_pago
      "Pago de facturas"
    end

    def company_reference
      @payment_order.company_id
    end

    def user_reference
      @payment_order.user_id
    end

    def entity_reference
      @payment_order.entity_id
    end
  end
end
