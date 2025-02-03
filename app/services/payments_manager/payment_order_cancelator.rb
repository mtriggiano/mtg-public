module PaymentsManager
  # Autor: Ariel Agustín García Sobrado
  #
  # Responsabilidad: Genera movimientos opuestos para los pagos antes confirmados
  # y vuelve atrás los pagos de las facturas asociadas en una Orden de Pago (anulada)
  #
  # Fix: Actualiza los balances para cada pago.
  #
  class PaymentOrderCancelator < PaymentsManager::PaymentService
    def initialize(payment_order)
      @payment_order = payment_order
    end

    def call
      ActiveRecord::Base.transaction do
        cancela_pago_de_facturas_asociadas
        vuelve_pagos_atras
      end
    end

    private

    def cancela_pago_de_facturas_asociadas
      @payment_order.details.each do |detail|
        if detail.bill
    			bill_total_left = detail.bill.total_left + detail.total.abs
    			bill_total_paid = detail.bill.total_pay - detail.total.abs

          detail.bill.update_columns(total_pay: bill_total_paid, total_left: bill_total_left)
    		end
      end
    end

    def vuelve_pagos_atras
      @payment_order.payments.includes([:payment_type]).each do |detail_bill|
        if imputa_en_caja?(detail_bill)
          case tipo_de_pago(detail_bill)
          when "Efectivo ($)"
            genera_egreso_efectivo(detail_bill)
          when "Efectivo (U$S)"
            genera_egreso_efectivo(detail_bill)
          when "Cheque"
            elimina_cheque_emitido(detail_bill)
          end
        end
        actualiza_balance_de_forma_de_pago(detail_bill)
      end
    end

    def genera_egreso_efectivo(detail)
      expense = @payment_order.payment_expenses.new.tap do |expense|
        expense.codigo       = codigo_comprobante
        expense.descripcion  = descripcion_de_pago
        expense.cash_account = caja_de_pago(detail)
        expense.importe      = -importe_de_pago(detail)
        expense.forma        = tipo_de_pago(detail)
        expense.fecha        = Date.today
        expense.lugar        = @payment_order.supplier.name
        expense.company_id   = company_reference
        expense.user_id      = user_reference
      end
      expense.save!
    end

    def elimina_cheque_emitido(detail)
      cheques = @payment_order.emitted_checks
      cheques.destroy_all unless cheques.empty?
    end

    def actualiza_balance_de_forma_de_pago(detail)
      payment_type = detail.payment_type
      payment_type.balance += importe_de_pago(detail)
      payment_type.save!
    end

    def codigo_comprobante
      @payment_order.name
    end

    def descripcion_de_pago
      "Orden de pago anulada"
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
