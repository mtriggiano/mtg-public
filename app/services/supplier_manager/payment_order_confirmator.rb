module SupplierManager
  class PaymentOrderConfirmator < SupplierManager::AccountMovementGenerator
    def initialize(payment_order)
      @payment_order = payment_order
      @supplier      = payment_order.supplier
    end

    private

    def genera_movimiento
      am = AccountMovement.expenses.new.tap do |am|
        am.payment_order_id  = @payment_order.id
        am.entity_id         = @supplier.id
        am.cbte_tipo         = concepto
        am.date              = Date.today
        am.total             = @payment_order.total
        am.balance           = calcula_balance
      end
      am.save!
    end

    def calcula_balance
      @supplier.current_balance - @payment_order.total
    end

    def concepto
      @payment_order.name ## OP-00020299
    end
  end
end
