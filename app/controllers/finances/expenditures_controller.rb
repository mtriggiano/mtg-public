class Finances::ExpendituresController < ApplicationController
  expose :expenditures, ->{ current_company.expenditures.order("expense_details.fecha DESC") }
  expose :expenditure, scope: ->{ expenditures }
  include Indexable

	def create
		if expenditure.save
      SupplierManager::ExpenditureConfirmator.call(expenditure)
			redirect_to expenditures_path, notice: "Gasto registrado correctamente."
		else
      pp expenditure.errors
			render :new
		end
	end

	def update
		if expenditure.update(expenditure_params)
			redirect_to expenditures_path, notice: "El gasto fue actualizado correctamente."
		else
			render :edit
		end
	end

  def destroy
    expenditure.destroy
    redirect_to expenditures_path, notice: "El registro de gasto fue eliminado."
  end

	private

	def expenditure_params
		params.require(:expenditure).permit(:descripcion, :total, :fecha_registro, :sum_iva, :percep_iva, :percep_iibb, :no_gravados, :fecha, :entity_id, :supplier_name, :letra, :punto_venta, :num_comprobante)
	end
end
