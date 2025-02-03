class ExpedientReceiptDetail < ApplicationRecord
	STATES = []
	#include ProductDetails
	TABLE_COLUMNS = {
        "Factura"          	=> {"important" => true,  "fixed" => false},
        "Monto faltante" 	=> {"important" => true,  "fixed" => false},
        "Subtotal ($)"      => {"important" => true,  "fixed" => true},
        "Acción"            => {"important" => true,  "fixed" => true}
    }
end
