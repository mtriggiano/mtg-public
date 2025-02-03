class Sales::ShipmentDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:entity, :file)
  end

end
