module SupplierManager
  class CashAccountExpenditureConfirmator < SupplierManager::AccountMovementGenerator
    attr_reader :expenditure
    attr_accessor :supplier

    def initialize(expenditure)
      @expenditure = expenditure
      @supplier    = expenditure.supplier
    end

    private

    def genera_movimiento
      am = AccountMovement.expenses.new.tap do |am|
        am.cbte_tipo                = "#{expenditure.codigo_comprobante} - GASTO CAJA"
        am.total                    = expenditure.total
        am.balance                  = supplier.current_balance + expenditure.total
        am.entity_id                = supplier.id
        am.date                     = expenditure.fecha
      end
      am.save!

      am = AccountMovement.incomes.new.tap do |am|
        am.cbte_tipo                = "#{expenditure.codigo_comprobante} - GASTO CAJA"
        am.total                    = expenditure.total
        am.balance                  = supplier.current_balance
        am.entity_id                = supplier.id
        am.date                     = expenditure.fecha
      end
      am.save!
    end

    def calcula_balance
      supplier.current_balance
    end
  end
end
