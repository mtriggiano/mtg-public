class Tenders::ShipmentDetail < ExpedientShipmentDetail
	include ProductDetails
	belongs_to :shipment, foreign_key: :shipment_id, inverse_of: :details, optional: true
	has_many :orders, through: :shipment
	has_many :order_details,
	        ->(detail){ where(product_id: detail.product_id) },
	        through: :orders,
	        source: :details

	has_one  :file, through: :shipment

	store_accessor :custom_attributes,
	         :consumed,
	         :consumption_detail_id,
	         :consumption_state,
	         :consumed_quantity

    def merge_with_order
    	order_details.each do |order_detail|
			order_detail.sended             	= true
			order_detail.shipment_detail_id   	= id
			order_detail.shipment_state       	= shipment.state
			order_detail.sended_quantity    	= quantity
			order_detail.save
	    end
    end

    def info
    	if consumed
    		{steps:[{title: "El producto fue consumido por el cliente.", description: "El producto fue asociado a un consumo con estado #{consumption_state}. Se consumieron #{consumed_quantity} #{product_measurement}."}]}
    	else
    		{steps:[{title: "No se registro consumo.", description: "No se registro consumo por parte del cliente."}]}
    	end
    end

    def state_text
    	if consumed
    		"Consumo registrado"
    	else
    		"Consumo sin registrar"
    	end
    end
end
