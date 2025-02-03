class Finances::EmittedCheckDatatable < ApplicationDatatable
  def get_raw_records
    @collection.joins(:supplier)
  end
end
