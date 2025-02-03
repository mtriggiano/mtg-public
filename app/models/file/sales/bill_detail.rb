class Sales::BillDetail < ExpedientBillDetail
  include ProductInheritance
  belongs_to :bill, class_name: "Sales::Bill", foreign_key: :bill_id, inverse_of: :details, optional: true


  TABLE_COLUMNS = {
    "Número"        => {"important" => true,  "fixed" => false},
    "Tipo"          => {"important" => true,  "fixed" => false},
    "Vendedor"      => {"important" => true,  "fixed" => false},
    "Descripción"   => {"important" => true,  "fixed" => false},
    "Código"        => {"important" => true,  "fixed" => false},
    "Marca"         => {"important" => true,  "fixed" => false},
    "Cantidad"      => {"important" => true,  "fixed" => false},
    "Precio bruto"  => {"important" => true,  "fixed" => false},
    "Descuento (%)" => {"important" => false, "fixed" => false},
    "IVA (%)"       => {"important" => true,  "fixed" => false},
    "Subtotal"      => {"important" => true,  "fixed" => true },
    "Acción"        => {"important" => true,  "fixed" => true }
  }

  def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil) # so_detail can be a child too
      #if so_detail.product_id.nil?
      #  self.mark_for_destruction
      #else
        self.reload if self.marked_for_destruction?
      #end
      self.product_id             = so_detail.product_id
      self.product_name           = so_detail.product_name
      self.product_measurement    = so_detail.inventary.medida unless so_detail.is_a_service?
      self.product_code           = so_detail.product_code || so_detail.product.code
      self.price                  += so_detail.price.round(4)
      self.iva_aliquot            = so_detail.iva_aliquot
      self.iva_amount             += so_detail.iva_amount.to_f
      self.discount               = so_detail.discount
      self.total                  += so_detail.total.round(4)
      self.subtype                = so_detail.is_a_service? ? "Sales::BillService" : "Sales::BillInventary"
      self.seller_id              = so_detail.user_id
      unless skip_filter_inheritance
        self.quantity               += so_detail.quantity - so_detail.bill_quantity.to_i
      else
        self.quantity               = so_detail.quantity
      end
      self.mark_for_destruction if self.quantity == 0
  end

  def is_a_product?
    self.subtype == "Sales::BillInventary"
  end

  def is_a_service?
    self.subtype == "Sales::BillService"
  end

  def tipo
    is_a_service? ? "Servicio" : "Producto"
  end
end
