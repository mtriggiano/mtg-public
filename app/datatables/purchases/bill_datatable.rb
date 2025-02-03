class Purchases::BillDatatable < ApplicationDatatable

  def get_raw_records
    @collection.includes(:supplier, :credit_notes, :debit_notes)
  end

end
