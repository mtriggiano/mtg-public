class Sales::ShipmentDetail < ExpedientShipmentDetail
	include ProductDetails
	include ProductInheritance
  belongs_to :shipment, foreign_key: :shipment_id, inverse_of: :details, optional: true

	has_one  :file, through: :shipment

    TABLE_COLUMNS = {
		'#' => { 'important' => true,  'fixed' => false },
    'Producto' => { 'important' => true,  'fixed' => false },
    'Código de producto' => { 'important' => false, 'fixed' => false },
    'Marca' => { 'important' => false, 'fixed' => false },
    'Cantidad' => { 'important' => true,  'fixed' => false },
    'Trazabilidad' => { 'important' => false, 'fixed' => false },
    'Observación' => { 'important' => false, 'fixed' => false },
    'Acción' => { 'important' => true, 'fixed' => true }
  }

    def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil)
        super do |d|
            d.quantity += so_detail.quantity - so_detail.shipment_quantity.to_i
            d.mark_for_destruction if d.quantity == 0
        end
    end
end
