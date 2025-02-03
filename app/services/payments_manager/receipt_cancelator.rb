module PaymentsManager
  # Autor: Ariel Agustín García Sobrado
  #
  # Responsabilidad: Genera movimientos opuestos para los cobros antes confirmados
  # y vuelve atrás los cobros de las facturas asociadas en Recibo (anulado)
  #
  # Fix: Actualiza los balances para cada pago.
  #
  class ReceiptCancelator < PaymentsManager::PaymentService
    def initialize(receipt)
      @receipt = receipt
    end

    def call
      ActiveRecord::Base.transaction do
        vuelve_facturas_atras
        vuelve_pagos_atras
      end
    end

    private

    def vuelve_facturas_atras
      @receipt.details.each do |detail|
        if detail.bill
    			bill_total_left = detail.bill.total_left + detail.total
    			bill_total_paid = detail.bill.total_pay - detail.total

          detail.bill.update_columns(total_pay: bill_total_paid, total_left: bill_total_left)
    		end
      end
    end

    def vuelve_pagos_atras
      receipt_details.each do |detail_bill|
        if imputa_en_caja?(detail_bill)
          case tipo_de_pago(detail_bill)
          when "Cheque"
            genera_ingreso_cheque(detail_bill)
            genera_egreso_cheque(detail_bill)
            elimina_cheque_en_cartera(detail_bill)
          when "Pagaré"
            genera_ingreso_pagare(detail_bill)
            genera_egreso_pagare(detail_bill)
            elimina_pagare_en_cartera(detail_bill)
          else
            genera_egreso(detail_bill)
          end
        end
        actualiza_balance_de_forma_de_pago(detail_bill)
      end
    end

    def genera_egreso(detail)
      expense = @receipt.payment_expenses.new.tap do |expense|
        expense.codigo       = codigo_comprobante
        expense.descripcion  = descripcion_de_pago
        expense.cash_account = caja_de_pago(detail)
        expense.importe      = importe_de_pago(detail)
        expense.forma        = tipo_de_pago(detail)
        expense.fecha        = Date.today
        expense.lugar        = @receipt.client.name
        expense.company_id   = company_reference
        expense.user_id      = user_reference
      end
      expense.save!
    end

    def genera_ingreso_cheque(detail)
      income = @receipt.payment_incomes.new.tap do |income|
        income.codigo       = codigo_comprobante
        income.descripcion  = "Recibo anulado"
        income.cash_account = caja_de_pago(detail)
        income.importe      = -importe_de_pago(detail)
        income.forma        = tipo_de_pago(detail)
        income.fecha        = Date.today
        income.lugar        = @receipt.client.name
        income.company_id   = company_reference
        income.user_id      = user_reference
      end
      income.save!
    end

    def genera_egreso_cheque(detail)
      expense = @receipt.bank_check_expenses.new.tap do |expense|
        expense.codigo       = detail.number
        expense.descripcion  = "Recibo anulado"
        expense.cash_account = caja_de_pago(detail)
        expense.importe      = -importe_de_pago(detail)
        expense.forma        = tipo_de_pago(detail)
        expense.fecha        = Date.today
        expense.lugar        = @receipt.client.name
        expense.company_id   = company_reference
        expense.user_id      = user_reference
      end
      expense.save!
    end

    def elimina_cheque_en_cartera(detail)
      cheques = BankCheckPayment.where(receipt_id: @receipt.id, numero_cheque: detail.number)
      cheques.destroy_all unless cheques.empty?
    end

    def genera_ingreso_pagare(detail)
      income = @receipt.payment_incomes.new.tap do |income|
        income.codigo       = codigo_comprobante
        income.descripcion  = "Recibo anulado"
        income.cash_account = caja_de_pago(detail)
        income.importe      = -importe_de_pago(detail)
        income.forma        = tipo_de_pago(detail)
        income.fecha        = Date.today
        income.lugar        = @receipt.client.name
        income.company_id   = company_reference
        income.user_id      = user_reference
      end
      income.save!
    end

    def genera_egreso_pagare(detail)
      expense = @receipt.promissory_note_expenses.new.tap do |expense|
        expense.codigo       = detail.number
        expense.descripcion  = "Recibo anulado"
        expense.cash_account = caja_de_pago(detail)
        expense.importe      = -importe_de_pago(detail)
        expense.forma        = tipo_de_pago(detail)
        expense.fecha        = Date.today
        expense.lugar        = @receipt.client.name
        expense.company_id   = company_reference
        expense.user_id      = user_reference
      end
      expense.save!
    end

    def elimina_pagare_en_cartera(detail)
      pagares = PromissoryNotePayment.where(receipt_id: @receipt.id, numero_cheque: detail.number)
      pagares.destroy_all unless pagares.empty?
    end

    def actualiza_balance_de_forma_de_pago(detail)
      payment_type = detail.payment_type
      payment_type.balance -= importe_de_pago(detail)
      payment_type.save!
    end

    def receipt_details
      @receipt.payments.includes([:payment_type])
    end

    def codigo_comprobante
      @receipt.name(:short)
    end

    def descripcion_de_pago
      # "Pago de facturas"
      if @receipt.details.any?
        if @receipt.bills.any?
          "ANULADO: #{@receipt.bills.map{ |bill| bill.full_name }.join(", ")}"
        else
          "ANULADO: Pago a cuenta recibido"
        end
      else
        ## pago sin detalles
        "ANULADO: Pago recibo manual"
      end
    end

    def company_reference
      @receipt.company_id
    end

    def user_reference
      @receipt.user_id
    end

    def entity_reference
      @receipt.entity_id
    end
  end
end
