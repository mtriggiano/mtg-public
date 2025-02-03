module FinanceManager
  class ExpenditureExpenseGenerator < ApplicationService
    attr_reader :expenditure, :user

    def initialize(expenditure, user)
      @expenditure = expenditure
      @user = user
      @payment_type = expenditure.cash_account.payment_types.where(name: expenditure.tipo_pago).first
    end

    def call
      genera_gasto_en_caja
      actualiza_balance_de_forma_de_pago
    end

    private

    def genera_gasto_en_caja
      expense = expenditure.build_expenditure_expense.tap do |expense|
        expense.codigo       = expenditure.codigo_comprobante
        expense.descripcion  = expenditure.descripcion
        expense.user_id      = user.id
        expense.company_id   = expenditure.cash_account.company_id
        expense.importe      = expenditure.total
        expense.fecha        = expenditure.try(:fecha_registro) ||  expenditure.try(:fecha)
        expense.forma        = @payment_type.try(:collect_type) || "Efectivo ($)"
        expense.lugar        = expenditure.supplier_name
        expense.cash_account = expenditure.cash_account
      end
      expense.save!
    end

    def actualiza_balance_de_forma_de_pago
      if @payment_type.present?
        @payment_type.balance -= expenditure.total
        @payment_type.save
      end
    end
  end
end
