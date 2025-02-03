class Entities::Clients::ClientContactDatatable < ApplicationDatatable

  def get_raw_records
    @collection.order("entity_contacts.titular")
  end

end
