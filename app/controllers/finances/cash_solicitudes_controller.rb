class Finances::CashSolicitudesController < ApplicationController

  expose :cash_solicitudes, -> { current_company.cash_solicitudes }
  expose :cash_solicitude, scope: -> { cash_solicitudes }
  #include Indexable
  skip_load_and_authorize_resource
  before_action :set_permission, only: [:analyze, :evaluate, :refund, :finalize]

  def index
    pp params[:user_view]
    if request.format.json?
      if params[:user_view] == "true"
        solicitudes = current_user.cash_solicitudes.order(id: :desc)
      else
        solicitudes = cash_solicitudes
      end
      render json: Finances::CashSolicitudeDatatable.new(params, view_context: view_context, collection: solicitudes), status: 200
    else

    end
  end

  def all
    if request.format.json?
      render json: Finances::CashSolicitudeDatatable.new(params, view_context: view_context, collection: cash_solicitudes), status: 200
    end
  end

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "RetiroDeFondos-#{cash_solicitude.codigo}",
        layout: 'pdf.html',
        template: "/finances/cash_solicitudes/show",
        # zoom: 3.1,
        viewport_size: '1280x1024',
        page_size: 'A6',
        encoding:"UTF-8",
        orientation: "Landscape"
      end
    end
  end

  def print
    if cash_solicitude.finalizado?
      respond_to do |format|
        format.pdf do
          render pdf: "#{cash_solicitude.codigo}",
          layout: 'pdf.html',
          template: "/finances/cash_solicitudes/print",
          viewport_size: '1280x1024',
          page_size: 'A4',
          encoding:"UTF-8",
          orientation: "Landscape"
        end
      end
    else
      redirect_to request.referer, alert: "La solicitud debe cerrarse para poder imprimirla."
    end
  end

  def new
  end

  def create
    cash_solicitude.user = current_user
    if cash_solicitude.save
      redirect_to home_path(view: 'cash_solicitudes'), notice: 'Solicitud de fondos registrada.'
    else
      render :new
    end
  end

  def new_external
  end

  def create_external
    if cash_solicitude.save
      redirect_to general_cash_account_path(current_company.general_cash_account, view: "pendings"), notice: 'Solicitud de fondos registrada.'
    else
      render :new_external
    end
  end

  def update
    if cash_solicitude.update(cash_solicitude_params)
      redirect_to home_path(view: 'cash_solicitudes'), notice: 'Solicitud de fondos registrada.'
    else
      render :edit
    end
  end

  def evaluate
    cash_solicitude.evaluador = current_user
    cash_solicitude.fecha_eval = Date.today
    if cash_solicitude.update(cash_solicitude_params)
      if cash_solicitude.evaluacion
        cash_solicitude.aprobar!
      else
        cash_solicitude.rechazar!
      end
      redirect_to general_cash_account_path(current_company.general_cash_account, view: 'pendings')
    else
      render :analyze
    end
  end

  def complete
    dif = 1 - cash_solicitude.expense_details.count
    (dif).times.each { cash_solicitude.expense_details.build }
  end

  def update_expenses
    if cash_solicitude.update(cash_solicitude_params)
      redirect_to home_path(view: 'cash_solicitudes'), notice: 'Informe de gastos registrado.'
    else
      pp cash_solicitude.errors
      render :complete
    end
  end

  def refund
    if cash_solicitude.cash_withdrawal
      @total_gastos = cash_solicitude.expense_details.pluck(:total).inject(0) { |sum, importe| sum + importe }
      @a_rendir = cash_solicitude.cash_withdrawal.importe - @total_gastos
      cash_solicitude.build_cash_refund unless cash_solicitude.cash_refund
    else
      redirect_to cash_solicitude, alert: "Debe realizar el retiro correspondiente."
    end
  end

  def finalize
    if not cash_solicitude.finalizado?
      cr_params = cash_solicitude_params
      cr_params[:cash_refund_attributes][:user] = current_user
      cr_params[:cash_refund_attributes][:fecha] = Date.today
      if cash_solicitude.update(cr_params)
        FinanceManager::RefundIncomeGenerator.call(cash_solicitude)
        # SupplierManager::ExpenseDetailsConfirmator.call(cash_solicitude)
        redirect_to cash_solicitude, notice: 'Rendición registrada. Puede imprimir el informe correspondiente.'
      else
        render :refund
      end
    else
      redirect_to cash_solicitude, alert: "La solicitud ya fue finalizada anteriormente."
    end
  end

  private

  def set_permission
    authorize!(:manage, CashSolicitude)
  end

  def cash_solicitude_params
    params.require(:cash_solicitude).permit(:motivo, :nombre_solicitante, :descripcion, :fecha, :evaluacion, :monto_aprobado, :rechazo,
      expense_details_attributes: [:_destroy, :id, :fecha, :fecha_pago, :fecha_registro, :letra, :punto_venta, :num_comprobante, :supplier_name, :entity_id, :descripcion, :total, :sum_iva, :percep_iva, :percep_iibb, :no_gravados, :enabled, :order_id, :archived],
      cash_refund_attributes: [:_destroy, :id, :importe, :observacion])
  end
end
