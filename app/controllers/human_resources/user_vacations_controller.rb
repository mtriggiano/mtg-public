class HumanResources::UserVacationsController < ApplicationController
  expose :user_vacations, -> {current_company.user_vacations}
  expose :user_vacation, scope: -> {user_vacations}
  include Indexable
  include JustificationApprover

  def new
    # code
  end

  def edit
    # code
  end

  def create
    user_vacation.company_id = current_company.id
    user_vacation.creator_id = current_user.id
    if user_vacation.save
      redirect_to user_vacations_path, notice: "Vacaciones asignadas con éxito"
    else
      pp user_vacation.errors
      render :new
    end
  end

  def update
    # code
  end

  def destroy
    if user_vacation.destroy
      redirect_to user_vacations_path, notice: "Se eliminó el registro con éxito"
    else
      render :index
    end
  end

  def fill_days_asignations
    @vacation = UserVacation.new
    if !params[:user_id].blank?
      user = current_company.users.find(params[:user_id])
      unless user.blank?
        @debt_vacations = user.debt_vacations.where("user_debt_vacations.days > 0").order("year ASC").map{|a| ["#{a.year} - #{a.days} Días", a.id]}
        get_days = UserDebtVacation.find(@debt_vacations.first.last).days.to_i
        @max_days = get_days.nil? ? 0 : get_days
        @band = !@debt_vacations.blank?
        @message = "Al empleado no se le debe ningun día de vacaciones"
      end
    else
      @band = false
      @message = "Seleccione un empleado"
    end
    render template: '/human_resources/user_vacations/fill_days_asignations.js.erb'
  end

  def get_max_days_for_vac_days
    unless params[:user_debt_vacation_id].blank?
      dvac = UserDebtVacation.find(params[:user_debt_vacation_id])
      unless dvac.nil?
        pp dvac.days
        render json: {error: "no_error", max_days: dvac.days}
      else
        render json: {error: "error"}
      end
    else
      render json: {error: "error"}
    end

  end

  private

  def user_vacation_params
    params.require(:user_vacation).permit(:user_id, :attendant_id, :init_date, :days, :approved,
      days_asignations_attributes: [:id, :user_debt_vacation_id, :days, :_destroy],
    )
  end

  def user_vacation_approve_params
    params.require(controller_name.singularize.to_sym).permit(:reject_reason, :approver_id, :approved,
      attachments_attributes: [:id, :file, :original_filename, :_destroy],
    )
  end
end
