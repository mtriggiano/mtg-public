class DeliveryNoteDatatable < ApplicationDatatable
  def get_raw_records
    @collection.joins(:purchase_file, purchase_return: :supplier)
  end

end
