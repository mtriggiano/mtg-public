class Finances::ImprestClearingsController < ApplicationController
  expose :regular_cash_account, id: -> { params[:regular_cash_account_id] }
  expose :imprest_clearings, ->{ current_company.general_cash_account.imprest_clearings }
  expose :imprest_clearing, scope: -> { regular_cash_account.imprest_clearings }
  include Indexable
  skip_load_and_authorize_resource

  def show
    prepara_datos_para_edicion(imprest_clearing.regular_cash_account)
		respond_to do |format|
      format.html
      format.pdf do
        render pdf: "RendicionCC-#{imprest_clearing.id}",
        layout: 'pdf.html',
        template: "/finances/imprest_clearings/show",
        # zoom: 3.1,
        viewport_size: '1280x1024',
        page_size: 'A4',
        encoding:"UTF-8"
      end
    end
	end

  def new
    fecha = params[:fecha_de_busqueda] || Time.now
    prepara_datos_de_inicio(regular_cash_account, fecha.to_datetime)
  end

  def edit
    prepara_datos_para_edicion(regular_cash_account)
  end

  def create
    imprest_clearing.general_cash_account = current_company.general_cash_account
    imprest_clearing.user  = current_user
    imprest_clearing.fecha = DateTime.now
    imprest_clearing.cuenta_monedas_a_rendir = params[:cuenta_monedas_a_rendir]
    imprest_clearing.cuenta_monedas_saldo_en_caja = params[:cuenta_monedas_saldo_en_caja]
    if imprest_clearing.save
      redirect_to regular_cash_account_path(regular_cash_account, view: 'imprest_records'), notice: "Rendición registrada."
    else
      prepara_datos_de_inicio(regular_cash_account, imprest_clearing.fecha)
      render :new
    end
  end

  def update
    if imprest_clearing.pendiente?
      imprest_clearing.fecha ||= DateTime.now
      imprest_clearing.cuenta_monedas_a_rendir = params[:cuenta_monedas_a_rendir]
      imprest_clearing.cuenta_monedas_saldo_en_caja = params[:cuenta_monedas_saldo_en_caja]
      if imprest_clearing.update(imprest_clearing_params)
        redirect_to edit_regular_cash_account_imprest_clearing_path(regular_cash_account, imprest_clearing), notice: "Rendición actualizada."
      else
        prepara_datos_para_edicion(regular_cash_account)
        render :edit
      end
    else
      redirect_to edit_regular_cash_account_imprest_clearing_path(regular_cash_account, imprest_clearing), notice: "La rendición no puede ser actualizada."
    end
  end

  def analyze
    prepara_datos_para_edicion(regular_cash_account)
  end

  def confirm
    if !imprest_clearing.confirmado?
      imprest_clearing.cuenta_monedas_a_rendir = params[:cuenta_monedas_a_rendir]
      imprest_clearing.cuenta_monedas_saldo_en_caja = params[:cuenta_monedas_saldo_en_caja]
      if imprest_clearing.update(imprest_clearing_params)
        confirmed_imprest_clearing = FinanceManager::ImprestClearingConfirmator.call(imprest_clearing, current_user)
        if confirmed_imprest_clearing.errors.empty?
          redirect_to general_cash_account_path(current_company.general_cash_account), notice: "Rendición confirmada."
        else
          prepara_datos_para_edicion(regular_cash_account)
          render :edit
        end
      else
        prepara_datos_para_edicion(regular_cash_account)
        render :edit
      end
    else
      redirect_to edit_regular_cash_account_imprest_clearing_path(regular_cash_account, imprest_clearing), notice: "La rendición no puede ser actualizada. Estado: [CONFIRMADA]."
    end
  end

  private

  def imprest_clearing_params
    params.require(:imprest_clearing).permit(:fondo_fijo, :fecha, :a_rendir, :saldo_en_caja, :saldo_inicio, :observaciones)
  end

  def prepara_datos_de_inicio(cash_account, fecha)
    @transactions = []
    fecha_final = Time.new(fecha.year, fecha.month, fecha.day, 00, 00) + 1.days
    rendiciones = cash_account.imprest_clearings.confirmados.order(:tiempo_de_confirmacion)
    if rendiciones.blank?
      imprest_clearing.saldo_inicio = 0
      imprest_clearing.fondo_fijo   = 2000
      @transactions = cash_account.logs.order(:id)
    else
      ultima_rendicion = rendiciones.last
      imprest_clearing.saldo_inicio = ultima_rendicion.saldo_en_caja
      imprest_clearing.fondo_fijo   = ultima_rendicion.fondo_fijo
      @transactions = cash_account.logs.where("created_at BETWEEN ? AND ?", ultima_rendicion.tiempo_de_confirmacion, fecha_final).order(:id)
    end
    asigna_totales_por_forma
  end

  def prepara_datos_para_edicion(cash_account)
    fecha_final = Time.new(imprest_clearing.fecha.year, imprest_clearing.fecha.month, imprest_clearing.fecha.day, 23, 59)
    if imprest_clearing.confirmado?
      ultima_rendicion = cash_account.imprest_clearings.where("id < ?", imprest_clearing.id).confirmados.order(:tiempo_de_confirmacion)
      if ultima_rendicion.blank?
        @transactions = cash_account.logs.where("created_at < ?", imprest_clearing.tiempo_de_confirmacion).order(:id)
      else
        @transactions = cash_account.logs.where("created_at BETWEEN ? and ?", ultima_rendicion.last.tiempo_de_confirmacion, imprest_clearing.tiempo_de_confirmacion).order(:id)
      end
    else
      rendiciones = cash_account.imprest_clearings.confirmados.order(:tiempo_de_confirmacion)
      if rendiciones.blank?
        @transactions = cash_account.logs
      else
        @transactions = cash_account.logs.where("created_at BETWEEN ? AND ?", rendiciones.last.tiempo_de_confirmacion, fecha_final).order(:id)
      end
    end
    asigna_totales_por_forma
  end

  def asigna_totales_por_forma
    @total_efectivo = @transactions.incomes.efectivo.pluck(:monto).inject(0, :+)
    @total_efectivo = @transactions.expenses.efectivo.pluck(:monto).inject(@total_efectivo, :-)

    @total_tarjeta = @transactions.incomes.tarjeta.pluck(:monto).inject(0, :+)
    @total_tarjeta = @transactions.expenses.tarjeta.pluck(:monto).inject(@total_tarjeta, :-)
    #
    # @total_transferencias = @transactions.incomes.transferencias.pluck(:monto).inject(0, :+)
    # @total_transferencias = @transactions.expenses.transferencias.pluck(:monto).inject(@total_transferencias, :-)
  end
end
