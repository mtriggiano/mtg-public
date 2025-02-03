module SaleManager

  class ShipmentGenerator

    def initialize bill
      @bill = bill
    end

    def call
      create_shipment
    end


    private

    def create_shipment
      shipment = Sales::Shipment.new(file_id: @bill.file_id, company_id: @bill.company_id, user_id: @bill.user_id, date: @bill.cbte_fch, entity_id: @bill.entity_id)
      shipment.current_user = @bill.current_user
      @bill.details.where.not(product_id: nil).each do |detail|
        shipment.details.new(
          product_id: detail.product_id,
          quantity: detail.quantity,
          product_name: detail.product_name,
          product_code: detail.product_code,
          product_measurement: detail.product_measurement,
          custom_detail: false,
          cumpliment: true
        )
      end
      if shipment.save
        shipment.shipments_bills.where(bill_id: @bill.id).first_or_create
      else
        shipment.errors.add("Remito", "Hubo un error al generar el remito automaticamente")
        pp shipment.errors
      end
    end
  end
end
