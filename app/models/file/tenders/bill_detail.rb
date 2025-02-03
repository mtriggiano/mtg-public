class Tenders::BillDetail < ExpedientBillDetail
  belongs_to :bill, class_name: "Tenders::Bill", foreign_key: :bill_id, optional: true
  has_many   :orders, through: :bill


  TABLE_COLUMNS = {
    "Tipo"          => {"important" => true,  "fixed" => false},
    "Vendedor"      => {"important" => true,  "fixed" => false},
    "Descripción"   => {"important" => true,  "fixed" => false},
    "Cantidad"      => {"important" => true,  "fixed" => false},
    "Medida"        => {"important" => false, "fixed" => false},
    "Precio bruto"  => {"important" => true,  "fixed" => false},
    "Descuento (%)" => {"important" => false, "fixed" => false},
    "IVA (%)"       => {"important" => true,  "fixed" => false},
    "Subtotal"      => {"important" => true,  "fixed" => true },
    "Acción"        => {"important" => true,  "fixed" => true }
  }

  def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil) # so_detail can be a child too
      self.product_id             = so_detail.product_id
      self.product_name           = so_detail.product_name
      self.quantity               = so_detail.quantity
      self.product_measurement    = so_detail.inventary.medida
      self.product_code           = so_detail.product_code || so_detail.product.code
      self.price                  = so_detail.price.round(1)
      self.iva_aliquot            = so_detail.iva_aliquot
      self.discount               = so_detail.discount
      self.total                  = so_detail.total
      self.subtype                = "Tenders::BillInventary"
      self.seller_id              = so_detail.user_id
  end

  def is_a_product?
    self.subtype == "Tenders::BillInventary"
  end

  def is_a_service?
    self.subtype == "Tenders::BillService"
  end

  def tipo
    is_a_service? ? "Servicio" : "Producto"
  end
end
