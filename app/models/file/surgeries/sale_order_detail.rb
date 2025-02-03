class Surgeries::SaleOrderDetail < ExpedientOrderDetail
  self.abstract_stock = true
  self.ignored_columns = %w[product_measurement]
  include ProductInheritance
  belongs_to :user, optional: true


  TABLE_COLUMNS = {
    "Número"                => {"important" => false,  "fixed" => false},
    "⚫"                    => {"important" => false,  "fixed" => false},
    "Comisionante"          => {"important" => false, "fixed" => false},
    "Producto"              => {"important" => true, "fixed" => false},
    "Marca"                 => {"important" => true, "fixed" => false},
    "Origen"                => {"important" => true, "fixed" => false},
    "Cantidad solicitada"   => {"important" => true, "fixed" => false},
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

  def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil)
    super do |d|
        d.quantity += so_detail.quantity - so_detail.order_quantity.to_i
        d.total                 += (so_detail.price * d.quantity * (1 - so_detail.discount / 100) + (so_detail.iva_amount / d.quantity)).round(4)
        d.user_id = so_detail.try(:budget).try(:seller_id)
        d.mark_for_destruction if d.quantity == 0
    end
  end

  def info
    state_info = {steps: []}
    if billed
      state_info[:steps].push({
        title: "Facturado", description: "La orden de venta fue facturada al clinte. El comprobante se encuentra en estado #{bill_state}. Se facturó #{bill_quantity} #{product_measurement}"
      })
    end
    if shipmented
      state_info[:steps].push({
        title: "Enviado", description: "El producto asociado fue enviado al cliente. El remito de salida se encuentra en estado #{shipment_state}.Se enviaron #{shipment_quantity} #{product_measurement}"
      })
    end
    if requested
      state_info[:steps].push({
        title: "Solicitado", description: "Se solicitó la reposición de stock del producto. La solicitud de encuentra en estado #{request_state}. Se solicitaron #{request_quantity} #{product_measurement}"
      })
    else
      state_info[:steps].push({
        title: "Esperando envío", description: "El producto esta disponible y listo para ser enviado al cliente."
      })
    end
    return state_info
  end
end
