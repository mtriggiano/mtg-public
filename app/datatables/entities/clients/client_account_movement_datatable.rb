class Entities::Clients::ClientAccountMovementDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:client).includes(:bill, :receipt)
  end

end
