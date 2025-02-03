class Purchases::BudgetDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:file)
  end

end
