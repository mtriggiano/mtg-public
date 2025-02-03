class Surgeries::PrescriptionDatatable < ApplicationDatatable
  def get_raw_records
    @collection.includes(:file, :client).joins(:file)
  end

end
