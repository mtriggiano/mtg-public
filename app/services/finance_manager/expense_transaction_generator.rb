module FinanceManager
  class ExpenseTransactionGenerator < ApplicationService
    def initialize(expense)
      @expense = expense
    end

    def call
      log = @expense.build_log.tap do |log|
        log.codigo       = @expense.codigo
        log.description  = @expense.descripcion
        log.date         = @expense.fecha
        log.monto        = @expense.importe
        log.user_id      = @expense.user_id
        log.forma        = @expense.forma
        log.cash_account = @expense.cash_account
        log.entidad      = @expense.lugar
        log.flow         = false
      end
      log.save!
    end
  end
end
