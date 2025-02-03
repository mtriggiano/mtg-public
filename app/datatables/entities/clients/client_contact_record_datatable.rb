class Entities::Clients::ClientContactRecordDatatable < ApplicationDatatable
  extend Forwardable

  def get_raw_records
    @collection
  end

end
