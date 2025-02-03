class Purchases::OrderDatatable < ApplicationDatatable

  def get_raw_records
    @collection.includes(:file, :entity).joins(:file)
  end

end
