class HumanResources::NonPresentUserDatatable < ApplicationDatatable

  def get_raw_records
    @collection.includes(:user, :attendance)
  end

end
