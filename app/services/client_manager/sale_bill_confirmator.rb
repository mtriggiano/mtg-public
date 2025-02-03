module ClientManager
  class SaleBillConfirmator < ApplicationService
    attr_accessor :bill, :client

    def initialize(sale_bill)
      @bill = sale_bill
      @client = sale_bill.client
    end

    def call
      genera_movimiento
      actualiza_balance_cliente(calcula_balance)
    end

    private

    def genera_movimiento
      am = AccountMovement.new.tap do |am|
        am.entity_id     = client.id
        am.bill_id       = @bill.id
        am.flow          = flow_por_tipo
        am.cbte_tipo     = concepto
        am.total         = @bill.total.round(2)
        am.balance       = calcula_balance
        am.date          = @bill.date
      end
      am.save!
    end

    def actualiza_balance_cliente(balance)
      client.update_column(:current_balance, balance)
    end

    def concepto
      bill.name(:short) ## FB-0001-00926627
    end

    def flow_por_tipo
      bill.is?(:credit_note) ? "expense" : "income"
    end

    def calcula_balance
      client.current_balance + total_por_tipo
    end

    def total_por_tipo
      return bill.total.round(2) if bill.is?(:credit_note)
      return - bill.total.round(2)
    end
  end
end
