class Finances::CashAccountExpendituresController < ApplicationController
  skip_load_and_authorize_resource
  expose :cash_account, id: -> { params[:cash_account_id] }
  expose :cash_account_expenditures, ->{ cash_account.expenditures }
	expose :cash_account_expenditure, scope: ->{ cash_account_expenditures }

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "#{cash_account_expenditure.codigo_recibo}",
        layout: 'pdf.html',
        template: "/finances/cash_account_expenditures/show",
        # zoom: 3.1,
        viewport_size: '1280x1024',
        page_size: 'A6',
        encoding:"UTF-8",
        orientation: "Landscape"
      end
    end
  end

	def create
		if cash_account_expenditure.save
      FinanceManager::ExpenditureExpenseGenerator.call(cash_account_expenditure, current_user)
      SupplierManager::CashAccountExpenditureConfirmator.call(cash_account_expenditure)
			redirect_to polymorphic_path(cash_account_expenditure.cash_account, fecha: cash_account_expenditure.fecha), notice: "Gasto de caja registrado correctamente."
		else
			render :new
		end
	end

  def destroy
    if cash_account_expenditure.active?
      FinanceManager::ExpenditureCancelator.call(cash_account_expenditure, current_user)
      if cash_account_expenditure.errors.empty?
        redirect_to request.referer, notice: "Gasto de caja anulado"
      else
        render :show
      end
    else
      redirect_to request.referer, alert: "El gasto de caja seleccionado fue anulado anteriormente."
    end
  end

	private

	def cash_account_expenditure_params
		params.require(:cash_account_expenditure).permit(:descripcion, :recibe, :tipo_pago, :representa, :total, :fecha, :fecha_registro, :entity_id, :supplier_name, :letra, :punto_venta, :num_comprobante, :sum_iva, :percep_iva, :percep_iibb, :no_gravados, :order_id)
	end
end
