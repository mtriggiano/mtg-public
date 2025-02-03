class Purchases::BillDetail < ExpedientBillDetail
  belongs_to :bill, class_name: "Purchases::Bill", foreign_key: :bill_id, optional: true
  has_many   :orders, through: :bill

  has_many :order_details,
            ->(detail){ where(product_id: detail.product_id) },
            through: :orders,
            source: :details

  # include Deleteable
  TABLE_COLUMNS = {
    "Número"          => {"important" => true,  "fixed" => false},
    "Tipo"          => {"important" => true,  "fixed" => false},
    "Producto"            => {"important" => true,  "fixed" => false},
    "Cantidad"            => {"important" => true,  "fixed" => false},
    "Precio bruto ($)"    => {"important" => true,  "fixed" => false},
    "Descuento (%)"       => {"important" => false, "fixed" => false},
    "I.V.A."              => {"important" => true,  "fixed" => false},
    "Subtotal"            => {"important" => true,  "fixed" => true},
    "Acción"              => {"important" => true,  "fixed" => true}
  }

  def build_childs(so_detail)
    nil
  end

  def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil) # so_detail can be a child too
    self.product_id             = so_detail.product_id
    self.product_name           = so_detail.product_name
    self.quantity               = so_detail.quantity
    self.product_measurement    = so_detail.inventary.medida
    self.product_code           = so_detail.product_code || so_detail.product.code
    self.price                  = so_detail.price.round(1)
    self.iva_amount             = so_detail.iva_amount.to_i
    self.iva_aliquot            = so_detail.iva_aliquot
    self.discount               = so_detail.discount
    self.total                  = so_detail.total
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
