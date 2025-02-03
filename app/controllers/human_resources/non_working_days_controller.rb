class HumanResources::NonWorkingDaysController < ApplicationController
  expose :non_working_days, -> {current_company.non_working_days}
  expose :non_working_day, scope: -> {non_working_days}

  include Indexable

  def create
    non_working_day.company_id = current_company.id
    if non_working_day.save
      redirect_to non_working_days_path, notice: "Feriado/Dia no laboral creado con éxito"
    else
      pp non_working_day.errors
      render :new
    end
  end

  def update
    non_working_day.company_id = current_company.id
    if non_working_day.update(non_working_day_params)
      redirect_to non_working_days_path, notice: "Actualización exitosa"
    else
      render :edit
    end
  end

  def destroy
    if non_working_day.destroy
      redirect_to non_working_days_path, notice: "Se eliminó el registro con éxito"
    else
      render :index
    end
  end

  private
  def non_working_day_params
    params.require(:non_working_day).permit(:date, :reason, :holiday_type, non_working_day_details_attributes: [:id, :user_id, :_destroy])
  end
end
