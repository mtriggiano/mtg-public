class Purchases::OrderDetail < ExpedientOrderDetail
  include ProductInheritance
  belongs_to :order, inverse_of: :details, optional: true
  
  TABLE_COLUMNS = {
    '#' => { 'important' => true, 'fixed' => false },
    'Producto' => { 'important' => true, 'fixed' => false },
    'Cantidad' => { 'important' => true, 'fixed' => false },
    'Código' => { 'important' => true, 'fixed' => false },
    'Marca' => { 'important' => true, 'fixed' => false },
    'Precio ($)' => { 'important' => true, 'fixed' => false },
    'Descuento (%)' => { 'important' => false, 'fixed' => false },
    'I.V.A. (%)' => { 'important' => true, 'fixed' => false },
    'Subtotal ($)' => { 'important' => true, 'fixed' => true },
    'Acción' => { 'important' => true, 'fixed' => true }
  }.freeze



  def assign_from_another sr_detail, recharge=nil, child=false, supplier_id=nil #sr_detail can be a child too
    super do |o|
      o.quantity += sr_detail.quantity.to_i - sr_detail.order_quantity.to_i
      o.price   = sr_detail.price
      o.mark_for_destruction unless o.quantity > 0
    end
  end
end
