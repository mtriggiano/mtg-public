module FinanceManager
  class BalanceCalculator < ApplicationService
    # calcula la diferencia (ingresos - egresos) para la fecha y caja seleccionada

    def initialize(fecha, cash_account)
      @fecha        = fecha
      @cash_account = cash_account
    end

    def call
      movimientos = @cash_account.logs.where(date: @fecha)
      ingresos = movimientos.incomes.pluck(:monto).inject(0) { |sum, monto| sum + monto }
      egresos = movimientos.expenses.pluck(:monto).inject(0) { |sum, monto| sum + monto }

      total = ingresos - egresos
    end
  end
end
