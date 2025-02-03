module PaymentsManager
  # Autor: Ariel Agustín García Sobrado
  #
  # Responsabilidad: Imputar los cobros y pagar las facturas asociadas en una Recibo (confirmada)
  # Fix: Actualiza los balances para cada pago.
  #
  class ReceiptConfirmator < PaymentsManager::PaymentService

    def initialize(receipt)
      @receipt = receipt
    end

    def call
      ActiveRecord::Base.transaction do
        paga_facturas_asociadas
        imputa_pagos
      end
    end

    private

    def paga_facturas_asociadas
      @receipt.receipt_details.includes(:bill).each do |detail|
        if detail.bill
          bill_total_left = detail.bill.total_left - detail.total
    			bill_total_paid = detail.bill.total_pay + detail.total

    			if detail.total >= detail.bill.total_left
    				detail.bill.pay_total!
    			else
    				detail.bill.update_columns(total_pay: bill_total_paid, total_left: bill_total_left)
    			end
    		end
      end
    end

    def imputa_pagos
      payment_details.each do |detail_bill|
        if imputa_en_caja?(detail_bill)
          pp tipo_de_pago(detail_bill)
          case tipo_de_pago(detail_bill)
          when "Cheque"
            genera_ingreso(detail_bill)
            genera_egreso_cheque(detail_bill)
            genera_cheque_en_cartera(detail_bill)
          when "Cheque electrónico"
            pp "askjñdaskjadskjl"
            genera_ingreso(detail_bill)
            genera_egreso_cheque(detail_bill)
            genera_cheque_en_cartera(detail_bill)
          when "Pagaré"
            genera_ingreso(detail_bill)
            genera_egreso_pagare(detail_bill)
            genera_pagare_en_cartera(detail_bill)
          else
            genera_ingreso(detail_bill)
          end
        end
        actualiza_balance_de_forma_de_pago(detail_bill)
      end
    end

    def genera_ingreso(detail)
      income = @receipt.payment_incomes.new.tap do |income|
        income.codigo       = codigo_comprobante
        income.descripcion  = descripcion_de_pago
        income.cash_account = caja_de_pago(detail)
        income.importe      = importe_de_pago(detail)
        income.forma        = tipo_de_pago(detail)
        income.fecha        = Date.today
        income.lugar        = @receipt.client.name
        income.company_id   = company_reference
        income.user_id      = user_reference
      end
      income.save
    end

    def genera_egreso_cheque(detail)
      expense = @receipt.bank_check_expenses.new.tap do |expense|
        expense.codigo       = detail.number
        expense.descripcion  = "Cheque en cartera"
        expense.cash_account = caja_de_pago(detail)
        expense.importe      = importe_de_pago(detail)
        expense.forma        = tipo_de_pago(detail)
        expense.fecha        = Date.today
        expense.lugar        = @receipt.client.name
        expense.company_id   = company_reference
        expense.user_id      = user_reference
      end
      expense.save
    end

    def genera_cheque_en_cartera(detail)
      cheque = BankCheckPayment.new(
          numero_cheque: detail.number,
          vencimiento: fecha_de_pago(detail),
          receipt_id: @receipt.id
        ).tap do |check|
          check.numero_cheque  = detail.number
          check.vencimiento    = fecha_de_pago(detail)
          check.importe        = importe_de_pago(detail)
          check.concepto       = @receipt.client.name
          check.entity_id      = entity_reference
          check.company_id     = company_reference
          check.receipt_id     = @receipt.id
        end
      unless cheque.save
        pp cheque.errors
      end
    end

    def genera_egreso_pagare(detail)
      expense = @receipt.promissory_note_expenses.new.tap do |expense|
        expense.codigo       = detail.number
        expense.descripcion  = "Pagaré en cartera"
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

    def genera_pagare_en_cartera(detail)
      pagare = PromissoryNotePayment.new(
          numero_cheque: detail.number,
          vencimiento: fecha_de_pago(detail),
          receipt_id: @receipt.id
        ).tap do |pagare|
          pagare.numero_cheque  = detail.number
          pagare.vencimiento    = fecha_de_pago(detail)
          pagare.importe        = importe_de_pago(detail)
          pagare.concepto       = @receipt.client.name
          pagare.entity_id      = entity_reference
          pagare.company_id     = company_reference
          pagare.receipt_id     = @receipt.id
        end
      pagare.save!
    end

    def actualiza_balance_de_forma_de_pago(detail)
      payment_type = detail.payment_type
      payment_type.balance += importe_de_pago(detail)
      payment_type.save!
    end

    def payment_details
      @receipt.payments.includes([:payment_type])
    end

    def codigo_comprobante
      @receipt.name(:short)
    end

    def descripcion_de_pago
      # "Pago de facturas"
      if @receipt.receipt_details.any?
        if @receipt.bills.any?
          @receipt.bills.map{ |bill| bill.full_name }.join(", ")
        else
          "Pago a cuenta recibido"
        end
      else
        ## pago sin detalles
        "Pago recibo manual"
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
