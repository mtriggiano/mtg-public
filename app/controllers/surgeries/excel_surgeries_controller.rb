class Surgeries::ExcelSurgeriesController < ApplicationController

  expose :surgeries_excel_surgeries, -> { Surgeries::ExcelSurgery.all.order("created_at DESC") }
  expose :surgeries_excel_surgery, scope: ->{ surgeries_excel_surgeries }

  def index

  end

  def new

  end

  def edit

  end

  def create
    surgeries_excel_surgery = Surgeries::ExcelSurgery.new(excel_surgery_params)
    if surgeries_excel_surgery.save
      redirect_to surgeries_excel_surgeries_path, notice: "Creado correctamente"
		else
      pp surgeries_excel_surgery.errors if Rails.env == "development"
      render template: '/surgeries/excel_surgeries/reload.js.erb'
		end
  end

  def update
		if @excel_surgery.update(excel_surgery_params)
      render template: '/surgeries/excel_surgeries/reload.js.erb'
		else
      pp record.errors if Rails.env == "development"
      render template: '/surgeries/excel_surgeries/reload.js.erb'
		end
	end

  def destroy
    @excel_surgery.destroy
    redirect_to surgeries_excel_surgeries_path, alert: "Eliminado correctamente"
  end

  private

  def excel_surgery_params
    params.require(:surgeries_excel_surgery).permit(:id, :paciente, :material, :fecha, :lugar, :transporte, :quirofano, :horario, :buscar_quirofano, :estado, :tipo_cx, :vendedor, :tecnico, :medico, :obs)
  end

end
