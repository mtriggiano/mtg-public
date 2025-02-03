module FinanceManager
  class WithdrawalExpenseGenerator < ApplicationService
    def initialize(withdrawal)
      @withdrawal = withdrawal
      @cash_solicitude = withdrawal.cash_solicitude
    end

    def call
      @cash_solicitude.entregar!
      # lugar = @cash_solicitude.user.nil? ? @cash_solicitude.nombre_solicitante : @cash_solicitude.user.name
      expense = @cash_solicitude.build_withdrawal_expense.tap do |expense|
        expense.codigo       = @cash_solicitude.codigo
        expense.descripcion  = @cash_solicitude.motivo
        expense.user_id      = @withdrawal.user_id
        expense.company_id   = @cash_solicitude.company_id
        expense.importe      = @withdrawal.importe
        expense.fecha        = @withdrawal.fecha
        expense.forma        = "Efectivo ($)" ## Siempre en efectivo
        expense.lugar        = @cash_solicitude.user.try(:name) || @cash_solicitude.nombre_solicitante
        expense.cash_account = @cash_solicitude.company.general_cash_account
      end
      expense.save!
    end
  end
end
