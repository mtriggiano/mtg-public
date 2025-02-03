class Purchases::DevolutionDatatable < ApplicationDatatable

  def get_raw_records
    @collection.includes(:supplier, :file).joins(:file)
  end

end
