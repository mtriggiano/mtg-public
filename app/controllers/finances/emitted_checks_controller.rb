class Finances::EmittedChecksController < ApplicationController
  include Indexable
  expose :emitted_checks, -> { current_company.emitted_checks }
  expose :emitted_check, scope: -> { emitted_checks }

  def create
    emitted_check = EmittedCheck.new(emitted_check_params)
    emitted_check.company_id = current_company.id
    emitted_check.importe_pagado = 0
    emitted_check.concepto = "Emisión sin OP"
    if emitted_check.save
      redirect_to emitted_check_path(emitted_check), notice: "Cheque emitido registrado correctamente."
    else
      render :new
    end
  end

  def update
    if emitted_check.update(emitted_check_params)
      redirect_to emitted_check_path(emitted_check), notice: "Cheque actualizado."
    else
      render :show
    end
  end

  private

  def emitted_check_params
    params.require(:emitted_check).permit(:checkbook_id, :numero, :vencimiento, :entity_id, :importe, :estado, :importe_pagado, check_amends_attributes: [:id, :_destroy, :descripcion])
  end
end
