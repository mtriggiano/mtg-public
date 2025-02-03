class Purchases::ArrivalDatatable < ApplicationDatatable

  def get_raw_records
    @collection.includes(:supplier)
  end

end
