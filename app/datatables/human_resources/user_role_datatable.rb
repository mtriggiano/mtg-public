class HumanResources::UserRoleDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:role)
  end

end
