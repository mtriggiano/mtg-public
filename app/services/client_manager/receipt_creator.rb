module ClientManager
  class ReceiptCreator
    def initialize current_user, op_name, date, company, cliente, payments
      @company = company
      @cliente = cliente
      @payments = payments
      @date = date
      @current_user = current_user
      @op_name = op_name
    end

    def perform
      receipt = initialize_receipt
      initialize_payments(receipt)
      save_receipt(receipt)
    end

    private

    def initialize_receipt
      receipt = ExpedientReceipt.new(client_payment_order: @op_name, company_id: @company.id, date: @date || Date.today)
      receipt.current_user = @current_user
      receipt.user_id = @current_user.id
      receipt.entity_id = get_entity_id(@cliente)
      return receipt
    end

    def initialize_payments receipt
      total_to_pay = @payments.map(&:total).reduce(:+)
      receipt.payments.build(
        total: total_to_pay,
        payment_type_id: @payments.first.payment_type_id
      )
    end

    def save_receipt receipt
      unless receipt.save
        pp receipt.errors
        raise ActiveRecord::Rollback
      end
    end

    def get_entity_id(cliente)
      client = Client.where(document_type: cliente.document_type, document_number: cliente.document_number, company_id: cliente.company_id).first
      if client.nil?
        raise ActiveRecord::Rollback
      else
        return client.id
      end
    end
  end
end
