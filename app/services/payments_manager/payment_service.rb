module PaymentsManager
  # Autor: Ariel Agustín García Sobrado
  #
  # Responsabilidad: Clase superior para registro de pagos (Ej: PaymentOrderConfirmator, ReceiptConfirmator)
  # Fix: Actualiza los balances para cada pago.
  #
  class PaymentService < ApplicationService

    private

    def imputa_en_caja?(detail)
      # return false if detail.bill_id.nil?
      detail.payment_type.imputed_in_cash?
    end

    def caja_de_pago(detail)
      detail.payment_type.cash_account
    end

    def importe_de_pago(detail)
      detail.total
    end

    def tipo_de_pago(detail)
      detail.payment_type.collect_type
    end

    def fecha_de_pago(detail)
      detail.due_date.nil? ? Date.today : detail.due_date
    end

    def chequera(detail)
      detail.checkbook_id
    end

    def bank_account(detail)
      detail.bank_account_id
    end

  end
end
