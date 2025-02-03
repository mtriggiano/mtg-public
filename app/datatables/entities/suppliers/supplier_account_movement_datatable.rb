class Entities::Suppliers::SupplierAccountMovementDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:supplier)
  end

end
