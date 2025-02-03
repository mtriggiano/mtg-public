class HumanResources::WorkStationsController < ApplicationController
  expose :work_stations, -> {current_company.work_stations}
  expose :work_station, scope: -> {work_stations}

  include Indexable

  def create
    work_station.company_id = current_company.id
    if work_station.save
      redirect_to work_stations_path, notice: "Puesto creado con éxito"
    else
      render :new
    end
  end

  def update
    work_station.company_id = current_company.id
    if work_station.update(work_station_params)
      redirect_to work_stations_path, notice: "Actualizacion exitosa"
    else
      render :edit
    end
  end

  def destroy
    if work_station.destroy
      redirect_to work_stations_path, notice: "Se eliminó el registro con éxito"
    else
      render :index
    end
  end

  # POST /work_stations
  # POST /work_stations.json
  private

  def work_station_params
    params.require(:work_station).permit(:company_id, :name, :description, :responsable_id)
  end
end
