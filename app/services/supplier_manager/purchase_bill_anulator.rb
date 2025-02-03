module SupplierManager
  class PurchaseBillAnulator < SupplierManager::AccountMovementGenerator

    def initialize(bill)
      @bill     = bill
      @supplier = bill.supplier
    end

    private

    def genera_movimiento
      am = SupplierAccountMovement.new.tap do |am|
        am.supplier      = @supplier
        am.bill_id       = @bill.id
        am.flow          = flow_por_tipo
        am.cbte_tipo     = concepto
        am.total         = @bill.total.round(2)
        am.balance       = calcula_balance
        am.date          = Date.today
      end
      am.save!
    end

    def calcula_balance
      @supplier.current_balance + total_por_tipo
    end

    def concepto
      "#{@bill.name(:short)} - ANULADO" ## 0001-00926627
    end

    def flow_por_tipo
      @bill.is?(:credit_note) ? "income" : "expense"
    end

    def total_por_tipo
      return -@bill.total.round(2) if @bill.is?(:bill)
      return @bill.total.round(2) if @bill.is?(:credit_note)
      return -@bill.total.round(2) if @bill.is?(:debit_note)
    end
  end
end
