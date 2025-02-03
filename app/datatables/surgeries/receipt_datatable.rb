class Surgeries::ReceiptDatatable < ApplicationDatatable

  def get_raw_records
    @collection.preload(:client)
  end

end
