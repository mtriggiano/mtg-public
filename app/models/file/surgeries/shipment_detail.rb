class Surgeries::ShipmentDetail < ExpedientShipmentDetail
	include ProductDetails
  include ProductInheritance
	has_one  :file, through: :shipment

    store_accessor :custom_attributes, :automatic_requested_quantity

    def check_stock(shipment_param=nil)
        update_column(:state, has_enough_stock?(shipment_param))
    end

    def arrival_details
        Surgeries::ArrivalDetail.where(
            arrival_id: file.arrivals.map(&:id),
            product_id: product_id
        )
    end

    def own?
        inventary && inventary.own
    end

    def info
    	if consumed
    		{steps:[{title: "El producto fue consumido por el cliente.", description: "El producto fue asociado a un consumo con estado #{consumption_state}. Se consumieron #{consumed_quantity} #{product_measurement}."}]}
    	else
    		{steps:[{title: "No se registro consumo.", description: "No se registro consumo por parte del cliente."}]}
    	end
    end

    def has_enough_stock?(shipment_param=nil)
			if shipment_param
				total_quantity = shipment_param.childs.map{|a| a.quantity if a.product_id == self.product_id}.compact.reduce(:+)
			else
				total_quantity = self.quantity
			end
			Stock::Manager.new(product: inventary).has_enough_stock?(total_quantity, store&.id) unless inventary.nil?
  	end

    def state_text
    	if consumptioned
    		"Consumo registrado"
    	else
    		"Consumo sin registrar"
    	end
    end

    def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil)
        super do |d|
            d.quantity += so_detail.quantity - so_detail.shipment_quantity.to_i
            d.mark_for_destruction if d.quantity == 0
        end
    end
end
