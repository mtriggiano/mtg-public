class Purchases::PurchaseRequestDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:file)
  end

end
