class Entities::Suppliers::SupplierDatatable < ApplicationDatatable

  def get_raw_records
    @collection.reorder("entities.current_balance ASC").includes(:contacts).joins("LEFT JOIN entity_contacts ON entities.id = entity_contacts.entity_id")
  end

end
