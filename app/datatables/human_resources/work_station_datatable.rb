class HumanResources::WorkStationDatatable < ApplicationDatatable

  def get_raw_records
    @collection.includes(:responsable).order("work_stations.name ASC")
  end

end
