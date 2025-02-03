module PaymentsManager
  class PromissoryPaymentCollector < ApplicationService
    attr_accessor :promissory_payment
    attr_reader :fecha_movimientos, :user

    def initialize(promissory_payment, user)
      @promissory_payment = promissory_payment
      @fecha_movimientos = Date.today
      @user = user
    end

    def call
      if @promissory_payment.receipt
        registra_movimiento_ingreso
        registra_movimiento_egreso
      else
        registra_movimiento_ingreso_sin_recibo
        registra_movimiento_egreso_sin_recibo
      end
      cheque_cobrado!
    end

    private

    def registra_movimiento_ingreso
      income = promissory_payment.receipt.payment_incomes.new.tap do |income|
        income.codigo       = promissory_payment.receipt.name(:short)
        income.descripcion  = "Depósito de #{promissory_payment.payment_type}"
        income.cash_account = promissory_payment.company.general_cash_account
        income.importe      = importe_pago
        income.forma        = tipo_pago
        income.lugar        = promissory_payment.client.name
        income.fecha        = fecha_movimientos
        income.company_id   = company_reference
        income.user_id      = user_reference
      end
      income.save!
    end

    def registra_movimiento_egreso
      expense = promissory_payment.receipt.bank_check_expenses.new.tap do |expense|
        expense.codigo       = promissory_payment.numero_cheque
        expense.descripcion  = "Depósito de #{promissory_payment.payment_type}"
        expense.cash_account = promissory_payment.company.general_cash_account
        expense.importe      = importe_pago
        expense.forma        = tipo_pago
        expense.lugar        = promissory_payment.client.name
        expense.fecha        = fecha_movimientos
        expense.company_id   = company_reference
        expense.user_id      = user_reference
      end
      expense.save!
    end

    def registra_movimiento_ingreso_sin_recibo
      income = PaymentIncome.new.tap do |income|
        income.codigo       = promissory_payment.numero_cheque
        income.descripcion  = "Depósito de #{promissory_payment.payment_type}"
        income.cash_account = promissory_payment.company.general_cash_account
        income.importe      = importe_pago
        income.forma        = tipo_pago
        income.lugar        = promissory_payment.client.name
        income.fecha        = fecha_movimientos
        income.company_id   = company_reference
        income.user_id      = user_reference
      end
      income.save!
    end

    def registra_movimiento_egreso_sin_recibo
      expense = Expense.new.tap do |expense|
        expense.codigo       = promissory_payment.numero_cheque
        expense.descripcion  = "Depósito de #{promissory_payment.payment_type}"
        expense.cash_account = promissory_payment.company.general_cash_account
        expense.importe      = importe_pago
        expense.forma        = tipo_pago
        expense.lugar        = promissory_payment.client.name
        expense.fecha        = fecha_movimientos
        expense.company_id   = company_reference
        expense.user_id      = user_reference
      end
      expense.save!
    end

    def cheque_cobrado!
      promissory_payment.update_columns(
        importe_cobrado: promissory_payment.importe,
        fecha_deposito: fecha_movimientos
      )
    end

    def company_reference
      promissory_payment.company_id
    end

    def user_reference
      user.id
    end

    def importe_pago
      promissory_payment.importe
    end

    def tipo_pago
      promissory_payment.payment_type
    end
  end
end
