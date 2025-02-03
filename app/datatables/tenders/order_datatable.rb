class Tenders::OrderDatatable < ApplicationDatatable
  def get_raw_records
    @collection.joins(:entity, :file)
  end

end
