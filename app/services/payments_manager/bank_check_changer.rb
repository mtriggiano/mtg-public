module PaymentsManager
  # AUTOR: Ariel Agustín García Sobrado
  #
  # RESPONSABILIDAD: Registrar los movimientos de caja correspondientes cuando se registra
  # el cambio de un cheque en cartera.
  class BankCheckChanger < ApplicationService
    attr_reader :new_bank_check, :old_bank_check, :user

    def initialize(old_bank_check, new_bank_check, user)
      @old_bank_check = old_bank_check
      @new_bank_check = new_bank_check
      @user = user
    end

    def call
      ActiveRecord::Base.transaction do
        ## el cheque reemplazado debe pasar por la caja
        registra_movimiento_ingreso(old_bank_check, "#{old_bank_check.payment_type} reemplazado")
        registra_movimiento_egreso(old_bank_check, "#{old_bank_check.payment_type} reemplazado")
        ## el NUEVO cheque debe pasar por la caja
        registra_movimiento_ingreso(new_bank_check, "#{new_bank_check.payment_type}  en cartera")
        registra_movimiento_egreso(new_bank_check, "#{new_bank_check.payment_type}  en cartera")
        ## el cheque reemplazado ya debe salir de la cartera
        cheque_cobrado!(old_bank_check)
      end
    end

    private

    def registra_movimiento_ingreso(cheque, descripcion)
      income = PaymentIncome.new.tap do |income|
        income.codigo       = cheque.numero_cheque
        income.descripcion  = descripcion
        income.cash_account = cheque.company.general_cash_account
        income.importe      = cheque.importe
        income.forma        = cheque.payment_type
        income.lugar        = cheque.client.name
        income.fecha        = Date.today
        income.company_id   = cheque.company_id
        income.user_id      = user.id
      end
      income.save!
    end

    def registra_movimiento_egreso(cheque, descripcion)
      expense = Expense.new.tap do |expense|
        expense.codigo       = cheque.numero_cheque
        expense.descripcion  = descripcion
        expense.cash_account = cheque.company.general_cash_account
        expense.importe      = cheque.importe
        expense.forma        = cheque.payment_type
        expense.lugar        = cheque.client.name
        expense.fecha        = Date.today
        expense.company_id   = cheque.company_id
        expense.user_id      = user.id
      end
      expense.save!
    end

    def cheque_cobrado!(cheque)
      cheque.cheque_reemplazado!
    end
  end
end
