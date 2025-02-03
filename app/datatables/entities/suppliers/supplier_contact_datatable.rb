class Entities::Suppliers::SupplierContactDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:supplier).order("entity_contacts.titular")
  end

end
