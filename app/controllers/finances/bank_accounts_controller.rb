module Finances
  class BankAccountsController < ApplicationController
    include Indexable
    skip_load_and_authorize_resource
    expose :bank_accounts, -> { current_company.bank_accounts.includes(:emitted_checks) }
    expose :bank_account, scope: ->{ bank_accounts }
    expose :emitted_checks, -> { bank_account.emitted_checks }
    expose :checks, -> { bank_account.bank_check_payments }
    expose :bank_transfer_payments, -> { bank_account.bank_transfer_payments }
    expose :emitted_transfer_payments, -> { bank_account.emitted_transfer_payments.includes(:payment_order) }

    def show
      @transactions = bank_account.transactions.order(fecha: :desc).paginate(per_page: 30, page: params[:page])
    end

    def create
      if bank_account.save
        redirect_to bank_account, notice: "Cuenta bancaria registrada."
      else
        render :new
      end
    end

    def update
      if bank_account.update(bank_account_params)
        redirect_to bank_account, notice: "Cuenta bancaria actualizada."
      else
        render :edit
      end
    end

    def load_transactions
      BankAccountsManager::BankAccountTransactionLoader.call(bank_account, params[:transaction_file])
      if bank_account.errors.empty?
        redirect_to bank_account, notice: 'Las transacciones bancarias están siendo procesadas. Serás notificado al terminar.'
      else
        show
        render :show
      end
  	end

    private

    def bank_account_params
      params.require(:bank_account).permit(:id, :alias_tag, :bank_id, :number, :cbu, :type)
    end
  end
end
