class Tenders::OrderDetail < ExpedientOrderDetail
	belongs_to :order, foreign_key: :order_id, inverse_of: :details, optional: true
	has_many :budgets, through: :order
	belongs_to :user, optional: true
	has_many :budget_details,
            ->(detail){ where(product_id: detail.product_id) },
            through: :budgets,
            source: :details

  	store_accessor :custom_attributes,
                 :requested,
                 :request_detail_id,
                 :request_state,
                 :requested_quantity,
                 :sended,
                 :shipment_detail_id,
                 :shipment_state,
                 :sended_quantity,
                 :billed,
                 :bill_detail_id,
                 :bill_state,
                 :billed_quantity

  	TABLE_COLUMNS = {
	    "⚫"                    => {"important" => false,  "fixed" => false},
	    "Comisionante"          => {"important" => false, "fixed" => false},
	    "Producto"              => {"important" => true, "fixed" => false},
	    "Cantidad solicitada"   => {"important" => true, "fixed" => false},
	    "Unidad de medida"      => {"important" => false, "fixed" => false},
	    "Precio"                => {"important" => true, "fixed" => false},
	    "Descuento (%)"         => {"important" => false, "fixed" => false},
	    "I.V.A. (%)"            => {"important" => true, "fixed" => false},
	    "Subtotal"              => {"important" => true, "fixed" => true},
	    "Acción"                => {"important" => true, "fixed" => true}
  	}

  	def has_enough_stock?
  		Stock::Manager.new(product: inventary).has_enough_stock?(quantity)
  	end

	def stock_needed
		quantity - Stock::Manager.new(product: inventary).available_stock
	end

  	def merge_with_budget
	    budget_details.each do |budget_detail|
	        budget_detail.ordered            = true
	        budget_detail.order_detail_id    = id
	        budget_detail.order_state        = order.state
	        budget_detail.order_quantity   = quantity
	        budget_detail.save
	    end
  	end

  	def info
	    state_info = {steps: []}
	    if billed
	      	state_info[:steps].push({
	        	title: "Facturado", description: "La orden de venta fue facturada al clinte. El comprobante se encuentra en estado #{bill_state}. Se facturó #{billed_quantity} #{product_measurement}"
	      	})
	    end
	    if sended
	      	state_info[:steps].push({
	        	title: "Enviado", description: "El producto asociado fue enviado al cliente. El remito de salida se encuentra en estado #{shipment_state}.Se enviaron #{sended_quantity} #{product_measurement}"
	      	})
	    end
	    if requested
	      	state_info[:steps].push({
	        	title: "Solicitado", description: "Se solicitó la reposición de stock del producto. La solicitud de encuentra en estado #{request_state}. Se solicitaron #{requested_quantity} #{product_measurement}"
	      	})
	    else
	      	state_info[:steps].push({
	        	title: "Esperando envío", description: "El producto esta disponible y listo para ser enviado al cliente."
	      	})
	    end
	    return state_info
  	end
end
