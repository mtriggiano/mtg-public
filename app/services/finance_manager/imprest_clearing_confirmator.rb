module FinanceManager
  class ImprestClearingConfirmator < ApplicationService
    attr_accessor :imprest_clearing
    attr_reader :regular_cash_account, :general_cash_account, :user

    def initialize(imprest_clearing, user)
      @imprest_clearing = imprest_clearing
      @regular_cash_account = imprest_clearing.regular_cash_account
      @general_cash_account = imprest_clearing.general_cash_account
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        if montos_correctos?
          reinicia_balances_de_caja_chica
          confirma_rendicion!
          registra_movimiento_en_caja_chica
          registra_movimiento_en_caja_general
        end

        return imprest_clearing
      end
    end

    private

    def montos_correctos?
      rendiciones_anteriores = regular_cash_account.imprest_clearings.confirmados
      if rendiciones_anteriores.any?
        fecha_de_busqueda = rendiciones_anteriores.last.tiempo_de_confirmacion
        transacciones = regular_cash_account.logs.where("created_at BETWEEN ? AND ?", fecha_de_busqueda, (@imprest_clearing.fecha + 1.days))
      else
        transacciones = regular_cash_account.logs
      end

      total_efectivo = transacciones.incomes.efectivo.pluck(:monto).inject(0, :+)
      total_efectivo = transacciones.expenses.efectivo.pluck(:monto).inject(total_efectivo, :+)

      if imprest_clearing.a_rendir > total_efectivo
        imprest_clearing.errors.add(:a_rendir, "El monto a rendir no puede ser superior al SubTotal de los movimientos en efectivo.")
        return false
      end
      return true
    end

    def reinicia_balances_de_caja_chica
      regular_cash_account.payment_types.each { |payment_type| payment_type.reinicia_balance! }
    end

    def registra_movimiento_en_caja_chica
      income = regular_cash_account.imprest_incomes.new.tap do |income|
        income.codigo       = ""
        income.descripcion  = "Saldo de inicio"
        income.lugar        = nil
        income.importe      = imprest_clearing.saldo_en_caja
        income.forma        = "Efectivo ($)"
        income.fecha        = Date.today
        income.company_id   = regular_cash_account.company_id
        income.user_id      = user.id
      end
      income.save!
    end

    def registra_movimiento_en_caja_general
      income = general_cash_account.imprest_incomes.new.tap do |income|
        income.codigo       = ""
        income.descripcion  = "Rendición de caja"
        income.lugar        = regular_cash_account.nombre
        income.importe      = imprest_clearing.a_rendir
        income.forma        = "Efectivo ($)"
        income.fecha        = Date.today
        income.company_id   = general_cash_account.company_id
        income.user_id      = user.id
      end
      income.save!
    end

    def confirma_rendicion!
      imprest_clearing.confirmar!
    end
  end
end
