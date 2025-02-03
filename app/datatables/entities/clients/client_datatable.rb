class Entities::Clients::ClientDatatable < ApplicationDatatable
  def get_raw_records
    @collection
  end

end
