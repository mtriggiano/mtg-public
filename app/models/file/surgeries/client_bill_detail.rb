class Surgeries::ClientBillDetail < ExpedientBillDetail
  self.abstract_stock = true
  include ProductInheritance
  TABLE_COLUMNS = {
    "Número"        => {"important" => true,  "fixed" => false},
    "Tipo"          => {"important" => true,  "fixed" => false},
    "Vendedor"      => {"important" => true,  "fixed" => false},
    "Descripción"   => {"important" => true,  "fixed" => false},
    "Cantidad"      => {"important" => true,  "fixed" => false},
    "Precio bruto"  => {"important" => true,  "fixed" => false},
    "Descuento (%)" => {"important" => false, "fixed" => false},
    "IVA (%)"       => {"important" => true,  "fixed" => false},
    "Subtotal"      => {"important" => true,  "fixed" => true },
    "Acción"        => {"important" => true,  "fixed" => true }
  }

  def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil) # so_detail can be a child too
      self.product_id             = so_detail.product_id
      self.product_name           = so_detail.product_name
      self.product_measurement    = so_detail.inventary.medida unless so_detail.inventary.nil?
      self.product_code           = so_detail.product_code || so_detail.product.code
      self.price                  += so_detail.price.round(1)
      self.iva_aliquot            = so_detail.iva_aliquot
      self.discount               = so_detail.discount
      self.total                  += so_detail.total
      self.subtype                = so_detail.is_a_service? ? "Surgeries::ClientBillService" : "Surgeries::ClientBillInventary"
      unless skip_filter_inheritance
        self.quantity               += so_detail.quantity - so_detail.bill_quantity.to_i
      else
        self.quantity               = so_detail.quantity
      end
      self.seller_id              = so_detail.user_id
      self.mark_for_destruction if self.quantity == 0
  end

  def not_only_products

  end

  def parent
    client_bill
  end

  def is_a_product?
    self.subtype == "Surgeries::ClientBillInventary"
  end

  def is_a_service?
    self.subtype == "Surgeries::ClientBillService"
  end

  def tipo
    is_a_service? ? "Servicio" : "Producto"
  end
end
