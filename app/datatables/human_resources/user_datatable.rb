class HumanResources::UserDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins("LEFT JOIN work_stations ON work_stations.id = users.work_station_id")
  end

end
