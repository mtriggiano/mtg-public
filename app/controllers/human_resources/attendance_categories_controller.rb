class HumanResources::AttendanceCategoriesController < ApplicationController
  expose :attendance_categories, -> {current_company.attendance_categories}
  expose :attendance_category, scope: -> {attendance_categories}

  include Indexable

  def create
    attendance_category.company_id = current_company.id
    if attendance_category.save
      redirect_to attendance_categories_path, notice: "Turno creado con éxito"
    else
      render :new
    end
  end

  def update
    attendance_category.company_id = current_company.id
    if attendance_category.update(attendance_category_params)
      redirect_to attendance_categories_path, notice: "Actualizacion exitosa"
    else
      render :edit
    end
  end

  def destroy
    if attendance_category.destroy
      redirect_to attendance_categories_path, notice: "Se eliminó el registro con éxito"
    else
      render :index
    end
  end

  # POST /attendance_categories
  # POST /attendance_categories.json
  private

  def attendance_category_params
    params.require(:attendance_category).permit(:company_id, :name, :early, :late, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday, :price_per_hour, :price_per_extra_hour, :check_in, :check_out)
  end
end
