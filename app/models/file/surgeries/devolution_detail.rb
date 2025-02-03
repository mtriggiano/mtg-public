class Surgeries::DevolutionDetail < ExpedientDevolutionDetail
	include ProductInheritance
  	TABLE_COLUMNS = {
  		"Número"              => { "important" => true,   "fixed" => false},
	    "Producto"            => { "important" => true,   "fixed" => false},
	    "Cantidad a devolver" => { "important" => true,   "fixed" => false},
	    "Trazabilidad"        => { "important" => true,   "fixed" => false},
	    "Razón de devolución" => { "important" => false,  "fixed" => false},
	    "Acción"              => { "important" => true,   "fixed" => true}
	}

	def assign_from_another sr_detail, recharge=nil, child=false, supplier_id=nil #sr_detail can be a child too
    	super do |o|
      		o.quantity              += sr_detail.quantity.to_i - sr_detail.devolution_quantity.to_i
      		o.mark_for_destruction unless o.quantity > 0
    	end
  	end
end
