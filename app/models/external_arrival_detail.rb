class ExternalArrivalDetail < ExpedientArrivalDetail
  self.ignored_columns = %w[product_supplier_code product_measurement]
  belongs_to :arrival, class_name: "ExternalArrival", foreign_key: :arrival_id, inverse_of: :details, optional: true
  include ProductInheritance

  scope :traslado_stock, -> {includes(:arrival).where(arrival: [traslado_stock_interno: true] )}

  TABLE_COLUMNS = {
    'Número' => { 'important' => false, 'fixed' => false },
    'Transacción' => { 'important' => false, 'fixed' => false },
    'Producto' => { 'important' => true, 'fixed' => false },
    'Código' => { 'important' => true, 'fixed' => false },
    'Marca' => { 'important' => true, 'fixed' => false },
    'Cantidad solicitada' => { 'important' => false, 'fixed' => false },
    'Cantidad recibida' => { 'important' => true, 'fixed' => false },
    'Trazabilidad' => { 'important' => true, 'fixed' => false },
    'Observación' => { 'important' => false, 'fixed' => false },
    'Acción' => { 'important' => true, 'fixed' => true }
  }.freeze


  def assign_from_another sr_detail, recharge=nil, child=false, supplier_id=nil #sr_detail can be a child too
    super do |o|
			if sr_detail.class.name.include?('Request')
				o.quantity += sr_detail.approved_quantity.to_i - sr_detail.arrival_quantity.to_i
        o.requested_quantity = o.quantity
			else
				o.quantity += sr_detail.quantity.to_i - sr_detail.arrival_quantity.to_i
			end
      o.mark_for_destruction unless o.quantity > 0
    end
  end


  def childs_attributes=(attrs)
    attrs.each do |_, det|
      det["entity_id"] = entity_id
    end
    super
  end
end
