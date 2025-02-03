module FinanceManager
  class IncomeTransactionGenerator < ApplicationService
    def initialize(income)
      @income = income
    end

    def call
      log = @income.build_log.tap do |log|
        log.codigo       = @income.codigo
        log.description  = @income.descripcion_completa
        log.date         = @income.fecha
        log.flow         = true
        log.monto        = @income.importe
        log.user_id      = @income.user_id
        log.forma        = @income.forma
        log.entidad      = @income.lugar
        log.cash_account = @income.cash_account
      end
      log.save!
    end
  end
end
