class Tenders::BillDatatable < ApplicationDatatable

  def get_raw_records
    @collection.includes(:entity, :file)
  end

end
