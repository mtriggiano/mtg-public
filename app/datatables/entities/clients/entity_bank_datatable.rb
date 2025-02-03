class Entities::Clients::EntityBankDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:entity)
  end

end
