class Surgeries::SupplierBillDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:file, :user)
  end

end
