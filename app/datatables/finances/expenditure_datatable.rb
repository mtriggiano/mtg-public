class Finances::ExpenditureDatatable < ApplicationDatatable
  def get_raw_records
    @collection.includes(:supplier).references(:supplier)
  end
end
