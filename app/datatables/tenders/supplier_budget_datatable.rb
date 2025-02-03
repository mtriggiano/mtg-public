class Tenders::SupplierBudgetDatatable < ApplicationDatatable
  def get_raw_records
    @collection.joins(:entity, :file)
  end
end
