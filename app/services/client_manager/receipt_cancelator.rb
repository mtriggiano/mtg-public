module ClientManager
  class ReceiptCancelator < ApplicationService
    attr_accessor :receipt, :client

    def initialize(receipt)
      @receipt = receipt
      @client  = receipt.client
    end

    def call
      genera_movimiento
      actualiza_balance_cliente(calcula_balance)
    end

    private

    def genera_movimiento
      am = AccountMovement.expenses.new.tap do |am|
        am.entity_id     = client.id
        am.receipt_id    = receipt.id
        am.cbte_tipo     = concepto
        am.date          = Date.today
        am.total         = - receipt.total.round(2)
        am.balance       = calcula_balance
      end
      am.save!
    end

    def actualiza_balance_cliente(balance)
      client.update_column(:current_balance, balance)
    end

    def concepto
      receipt.name(:short)
    end

    def calcula_balance
      client.current_balance - receipt.total.round(2)
    end
  end
end
