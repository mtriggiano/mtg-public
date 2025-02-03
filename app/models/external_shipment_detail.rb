class ExternalShipmentDetail < Surgeries::ShipmentDetail
  belongs_to :shipment, class_name: "ExternalShipment", foreign_key: :shipment_id, inverse_of: :details, optional: true
  include ProductInheritance

  scope :traslado_stock, -> {includes(:shipment).where("shipments.traslado_stock_interno = true" )}

  def has_enough_stock?(shipment_param=nil)
    if shipment_param
      total_quantity = shipment_param.childs.map{|a| a.quantity if a.product_id == self.product_id}.compact.reduce(:+)
    else
      total_quantity = self.quantity
    end
    Stock::Manager.new(product: inventary).has_enough_stock?(total_quantity, store&.id)
  end


end
