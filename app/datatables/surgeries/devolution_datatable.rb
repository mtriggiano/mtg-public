class Surgeries::DevolutionDatatable < ApplicationDatatable
  def get_raw_records
    @collection.joins(:supplier, :file)
  end

end
