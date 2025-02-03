class Finances::PromissoryPaymentsController < ApplicationController
  expose :promissory_payments, ->{ current_company.promissory_payments }
  expose :promissory_payment, scope: ->{ promissory_payments }
  include Indexable
  skip_load_and_authorize_resource
  before_action :set_permission

  def show
    if promissory_payment.new_bank_check
      redirect_to promissory_payment_path(promissory_payment.new_bank_check)
    end
    ## genera un pago igual para el registro de cambio
    if promissory_payment.class == BankCheckPayment
      @payment = current_company.bank_check_payments.new
    else
      @payment = current_company.promissory_note_payments.new
    end
  end

  private

  def set_permission
    authorize!(:manage, GeneralCashAccount)
  end

  def promissory_payment_params
    params.permit(:bank_account_id)
  end
end
