module FinanceManager
  class ImprestClearingGenerator

    def initialize fecha, caja
      @fecha = fecha
      @caja = caja
    end

    def call
      prepara_datos_de_inicio(@caja)
      pp @transactions.map{|a| a.created_at}
      return @transactions
    end


    private

    def prepara_datos_de_inicio(cash_account)
      imprest_clearing = ImprestClearing.new(fecha: @fecha)
      rendiciones = cash_account.imprest_clearings.confirmados
      if rendiciones.empty?
        imprest_clearing.saldo_inicio = 0
        imprest_clearing.fondo_fijo   = 2000
        @transactions = cash_account.logs.order(:id)
      else
        ultima_rendicion = rendiciones.last
        imprest_clearing.saldo_inicio = ultima_rendicion.saldo_en_caja
        imprest_clearing.fondo_fijo   = ultima_rendicion.fondo_fijo
        @transactions = cash_account.logs.where("created_at BETWEEN ? AND ?", ultima_rendicion.tiempo_de_confirmacion, @fecha.to_datetime).where.not(codigo: "").order(:id)
      end
      asigna_totales_por_forma
    end

    def asigna_totales_por_forma
      @total_efectivo = @transactions.incomes.efectivo.pluck(:monto).inject(0, :+)
      @total_efectivo = @transactions.expenses.efectivo.pluck(:monto).inject(@total_efectivo, :-)

      @total_tarjeta = @transactions.incomes.tarjeta.pluck(:monto).inject(0, :+)
      @total_tarjeta = @transactions.expenses.tarjeta.pluck(:monto).inject(@total_tarjeta, :-)
      #
      # @total_transferencias = @transactions.incomes.transferencias.pluck(:monto).inject(0, :+)
      # @total_transferencias = @transactions.expenses.transferencias.pluck(:monto).inject(@total_transferencias, :-)
    end

  end
end
