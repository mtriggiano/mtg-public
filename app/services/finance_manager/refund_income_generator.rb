module FinanceManager
  class RefundIncomeGenerator < ApplicationService
    def initialize(cash_solicitude)
      @cash_solicitude = cash_solicitude
    end

    def call
      @cash_solicitude.finalizar!
      income = @cash_solicitude.build_cash_refund_income.tap do |income|
        income.codigo         = @cash_solicitude.codigo
        income.descripcion    = @cash_solicitude.motivo
        income.user_id        = @cash_solicitude.cash_refund.user_id
        income.company_id     = @cash_solicitude.company_id
        income.importe        = @cash_solicitude.cash_refund.importe
        income.fecha          = @cash_solicitude.cash_refund.fecha
        income.forma          = "Efectivo ($)"
        income.lugar          = @cash_solicitude.user.try(:name) || @cash_solicitude.nombre_solicitante
        income.cash_account   = @cash_solicitude.company.general_cash_account
      end
      income.save!
    end
  end
end
