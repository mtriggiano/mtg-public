class Purchases::PaymentOrderDatatable < ApplicationDatatable

  def get_raw_records
    @collection.joins(:supplier).left_joins(:payment_types).left_joins(:taxes).distinct("payment_orders.id")
  end

end
