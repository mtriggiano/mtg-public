module SupplierManager
  class ExpenseDetailsConfirmator < ApplicationService
    attr_reader :cash_solicitude

    def initialize(cash_solicitude)
      @cash_solicitude = cash_solicitude
    end

    def call
      genera_movimientos_para_cada_gasto
    end

    private

    def genera_movimientos_para_cada_gasto
      cash_solicitude.expense_details.each do |expense|
        if expense.supplier
          genera_movimiento_negativo(expense)
          genera_movimiento_positivo(expense)
        end
      end
    end

    def genera_movimiento_negativo(expense)
      am = AccountMovement.expenses.new.tap do |am|
        am.cbte_tipo                = "F#{expense.codigo_comprobante} - SOLIC. DE FONDOS"
        am.total                    = expense.total
        am.balance                  = expense.supplier.current_balance + expense.total
        am.entity_id                = expense.supplier.id
        am.date                     = expense.fecha
      end
      am.save!
    end

    def genera_movimiento_positivo(expense)
      am = AccountMovement.incomes.new.tap do |am|
        am.cbte_tipo                = "F#{expense.codigo_comprobante} - SOLIC. DE FONDOS"
        am.total                    = expense.total
        am.balance                  = expense.supplier.current_balance
        am.entity_id                = expense.supplier.id
        am.date                     = expense.fecha
      end
      am.save!
    end
  end
end
