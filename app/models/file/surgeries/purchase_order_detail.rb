class Surgeries::PurchaseOrderDetail < ExpedientOrderDetail
  self.abstract_stock = true
  include ProductInheritance
  validates_presence_of :total, message: "Debe ingresar"
  validates_presence_of :price, message: "Debe ingresar"

  TABLE_COLUMNS = {
    'Número' => { 'important' => true, 'fixed' => false },
    'Producto' => { 'important' => true, 'fixed' => false },
    'Cantidad' => { 'important' => true, 'fixed' => false },
    'Precio ($)' => { 'important' => true, 'fixed' => false },
    'Descuento (%)' => { 'important' => false, 'fixed' => false },
    'I.V.A. (%)' => { 'important' => true, 'fixed' => false },
    'Subtotal ($)' => { 'important' => true, 'fixed' => true },
    'Acción' => { 'important' => true, 'fixed' => true }
  }.freeze


  def assign_from_another sr_detail, recharge=nil, child=false, supplier_id=nil #sr_detail can be a child too
    super do |o|
      o.total                 = sr_detail.try(:price) || sr_detail.try(:supplier_price) || 0
      o.price                 = (o.total.to_f / (sr_detail.quantity.to_f * (1 + o.iva.to_f))).round(1)
      o.quantity              += sr_detail.quantity.to_i - sr_detail.order_quantity.to_i

      o.mark_for_destruction unless o.quantity > 0
    end

  end

end
