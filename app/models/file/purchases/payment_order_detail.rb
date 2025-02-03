class Purchases::PaymentOrderDetail
	STATES = []
	TABLE_COLUMNS = {
        "Factura" 			=> {"important" => true,  "fixed" => false},
        "Monto faltante" 	=> {"important" => true,  "fixed" => false},
        "Tipo de pago" 		=> {"important" => true,  "fixed" => false},
        "Nº de chequera" 		=> {"important" => true,  "fixed" => false},
        "Nº de comprobante" => {"important" => true,  "fixed" => false},
        "Vencimiento" 		=> {"important" => true,  "fixed" => false},
        "Subtotal ($)"      => {"important" => true,  "fixed" => true},
        "Acción"            => {"important" => true,  "fixed" => true}
    }
end
