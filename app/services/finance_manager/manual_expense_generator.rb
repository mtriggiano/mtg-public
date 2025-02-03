module FinanceManager
  # Autor: Ariel Agustín García Sobrado
  #
  ## Responsabilidad: Actualizar el balance del tipo de pago seleccionado para un egreso de caja manual
  class ManualExpenseGenerator < ApplicationService
    attr_accessor :payment_type
    attr_reader :income

    def initialize(income, payment_type)
      @income = income
      @payment_type = payment_type
    end

    def call
      actualiza_balance_de_forma_de_pago
    end

    private

    def actualiza_balance_de_forma_de_pago
      payment_type.balance -= income.importe
      payment_type.save!
    end
  end
end
