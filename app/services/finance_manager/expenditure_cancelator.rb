module FinanceManager
  class ExpenditureCancelator < ApplicationService
    attr_accessor :expenditure
    attr_reader :user

    def initialize(cash_account_expenditure, user)
      @expenditure = cash_account_expenditure
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        elimina_gasto_y_movimiento_de_caja
        actualiza_balance_de_forma_de_pago
        anula_gasto
      end
    end

    private

    def elimina_gasto_y_movimiento_de_caja
      expenditure.expenditure_expense.destroy ## el mov de caja se elimina también
    end

    def actualiza_balance_de_forma_de_pago
      caja_imputada = expenditure.cash_account

      # Detecta si el gasto fue en pesos o en dólares, aceptando distintos formatos
      tipo_pago_collect_type = if expenditure.tipo_pago.include?("U$S")
                                 "Efectivo (U$S)"
                               elsif expenditure.tipo_pago.include?("Efectivo ($)")
                                 "Efectivo ($)"
                               else
                                 nil
                               end

      # Procede solo si se encuentra un tipo de pago
      if tipo_pago_collect_type
        tipo_pagos = caja_imputada.payment_types.where(collect_type: tipo_pago_collect_type)
        if tipo_pagos.any?
          tipo_de_pago = tipo_pagos.first
          tipo_de_pago.balance += expenditure.total
          tipo_de_pago.save
        end
      else
        raise "Tipo de pago no soportado"
      end
    end

    def anula_gasto
      expenditure.update_columns(
        disabled_time: DateTime.now,
        disable_user_id: user.id
      )
    end
  end
end