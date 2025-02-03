class Finances::GeneralCashAccountsController < ApplicationController
  skip_load_and_authorize_resource only: :print
  expose :general_cash_account, -> { current_company.general_cash_account }
  expose :transactions, -> { general_cash_account.logs.search(params[:search]).includes(:user).order(:created_at) }
  expose :incomes, -> { transactions.incomes.daily(params[:fecha] || Date.today) }
  expose :expenses, -> { transactions.expenses.daily(params[:fecha] || Date.today) }
  expose :initial_balances, -> { general_cash_account.initial_balances.daily(params[:fecha] || Date.today) }
  expose :imprest_clearings, -> { general_cash_account.imprest_clearings.search(params[:search]).order(fecha: :desc) }
  expose :cash_solicitudes, -> { current_company.cash_solicitudes.includes(:cash_withdrawal, :user).search(params[:search]).order(id: :desc) }
  expose :promissory_payments, -> { current_company.promissory_payments.search(params[:search]).pendientes.order(:vencimiento) }
  expose :expenditures, -> { general_cash_account.expenditures.daily(params[:fecha] || Date.today).search(params[:search]).limit(10) }

  def index
    begin
      redirect_to general_cash_account_path(current_company.general_cash_account, view: 'transactions')
    rescue StandardError => error
      CompanyManager::GeneralCashAccountGenerator.call(current_company)
      redirect_to general_cash_account_path(current_company.general_cash_account)
    end
  end

  def show
    @ingresos  = incomes.efectivo_pesos.pluck(:monto).inject(0, :+)
    @egresos   = expenses.efectivo_pesos.pluck(:monto).inject(0, :+)
    @total_hoy = @ingresos - @egresos
    @saldo_anterior = saldos_anteriores_en_pesos(params[:fecha] || Date.today)

    @saldo_efectivo_pesos = @saldo_anterior + @total_hoy
    @saldo_efectivo_dolares = saldo_en_dolares(params[:fecha] || Date.today)
    @saldo_cheques = current_company.bank_check_payments.pendientes.sum(:importe)
    @saldo_pagares = current_company.promissory_note_payments.pendientes.sum(:importe)
    @proximos_cheques = current_company.bank_check_payments.pendientes.where("vencimiento < ?", Date.today + 5.days).sum(:importe)
    @proximos_pagares = current_company.promissory_note_payments.pendientes.where("vencimiento < ?", Date.today + 5.days).sum(:importe)
  end

  def print
    begin
      authorize!(:read, GeneralCashAccount)
      params[:fecha] ||= Date.today
      @fecha = params[:fecha].to_date
      @hora = Time.now

      @egresos = expenses
      @ingresos = incomes
      @saldo_anterior_pesos   = saldos_anteriores_en_pesos(@fecha)
      @cheques                = current_company.promissory_payments.includes(:client).where("fecha_deposito is NULL or fecha_deposito > ?", @fecha).order(:vencimiento)

      @total_ingresos         = @ingresos.efectivo_pesos.pluck(:monto).inject(0, :+) + @saldo_anterior_pesos
      @total_egresos          = @egresos.efectivo_pesos.pluck(:monto).inject(0, :+)
      @saldo_efectivo_pesos   = @total_ingresos - @total_egresos
      @saldo_efectivo_dolares = saldo_en_dolares(@fecha)
      @saldo_cheques          = @cheques.map(&:importe).inject(0, :+)

      respond_to do |format|
        format.pdf do
          render pdf: "#{general_cash_account.nombre}-#{@fecha}",
          layout: 'pdf.html',
          template: "/finances/general_cash_accounts/print",
          viewport_size: '1280x1024',
          page_size: 'A4',
          encoding:"UTF-8",
          orientation: "Landscape"
        end
      end
    rescue
      redirect_to request.referer, alert: "Error al imprimir la caja del día."
    end
  end

  private

def saldos_anteriores_en_pesos(fecha)
  saldo = 0
  transactions.efectivo_pesos.where("cash_account_logs.date < ?", fecha.to_date).each do |log|
    log.income? ? (saldo += log.monto) : (saldo -= log.monto)
  end
  saldo
end

def saldo_en_dolares(fecha)
  saldo = 0
  transactions.efectivo_dolares.where("date <= ?", fecha.to_date).each do |log|
    log.income? ? (saldo += log.monto) : (saldo -= log.monto)
  end
  saldo
  end
end
