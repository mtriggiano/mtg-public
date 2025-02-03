class Sales::BillDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:expedient_file)
    .includes(:entity, budgets: :seller)
    .references(:entity, budgets: :seller)
    .distinct("bills.id")
  end

end
