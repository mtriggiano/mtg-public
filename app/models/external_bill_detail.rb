class ExternalBillDetail < ExpedientBillDetail
	include ProductDetails
  include ProductInheritance
	self.table_name = :bill_details
	self.abstract_stock = true
	belongs_to :external_bill, foreign_key: :bill_id, inverse_of: :details

	TABLE_COLUMNS = {
    "Número"          => {"important" => true,  "fixed" => false},
    "Tipo"          => {"important" => true,  "fixed" => false},
    "Producto"      => {"important" => true,  "fixed" => false},
    "Cantidad"      => {"important" => true,  "fixed" => false},
    "Precio bruto"  => {"important" => true,  "fixed" => false},
    "Descuento (%)" => {"important" => false, "fixed" => false},
    "IVA (%)"       => {"important" => true,  "fixed" => false},
    "Subtotal"      => {"important" => true,  "fixed" => true },
    "Acción"        => {"important" => true,  "fixed" => true }
  }

  def parent
    external_bill
  end

  def build_childs(so_detail)
    nil
  end

  def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil) # so_detail can be a child too
    self.product_id             = so_detail.product_id
    self.product_name           = so_detail.product_name
		self.discount               += (((self.discount * self.quantity) + (so_detail.discount * so_detail.quantity)) / (self.quantity + so_detail.quantity)).round(4)
    self.product_measurement    = so_detail.product_measurement
    self.product_code           = so_detail.product_code
    self.price                  = so_detail.price.round(4)
    self.iva_aliquot            = so_detail.iva_aliquot
    self.iva_amount             += so_detail.iva_amount
    self.total                  += so_detail.total
    self.quantity               += so_detail.quantity - so_detail.bill_quantity.to_i
    self.mark_for_destruction if self.quantity == 0
  end

  def is_a_product?
    self.subtype == "BillInventary"
  end

  def is_a_service?
    self.subtype == "BillService"
  end

  def tipo
    is_a_service? ? "Servicio" : "Producto"
  end
end
