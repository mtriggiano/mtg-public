class ExternalShipmentPresenter < Surgeries::ShipmentPresenter

  def entity
    shipment.client
  end
end
