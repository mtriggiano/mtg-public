class Surgeries::ArrivalDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:supplier, :file)
  end

end
