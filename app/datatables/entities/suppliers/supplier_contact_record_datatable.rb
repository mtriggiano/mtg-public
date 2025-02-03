class Entities::Suppliers::SupplierContactRecordDatatable < ApplicationDatatable
  extend Forwardable

  def get_raw_records
    @collection
  end

end
