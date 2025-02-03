module SupplierManager
  class AccountMovementGenerator < ApplicationService

    def call
      if @supplier
        genera_movimiento
        actualiza_balance_proveedor(calcula_balance)
      end
    end

    def actualiza_balance
      actualiza_balance_proveedor(calcula_balance)
    end

    private

    def actualiza_balance_proveedor(balance)
      @supplier.update_column(:current_balance, balance)
    end
  end
end
