class ExpedientReceiptDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:client)
  end

end
