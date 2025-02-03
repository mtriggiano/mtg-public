class Tenders::SaleRequestDetail < ExpedientRequestDetail
	self.abstract_stock = true
	belongs_to :sale_request, foreign_key: :request_id, inverse_of: :details, optional: true
  include ProductInheritance

    TABLE_COLUMNS = {
      "Número" =>               {"important" => false,  "fixed" => false},
      "" =>                     {"important" => false,  "fixed" => false},
      "Tipo" =>                 {"important" => true,  "fixed" => false},
      "Producto" =>             {"important" => true,   "fixed" => false},
      "Código" =>               {"important" => true,   "fixed" => false},
      "Marca" =>                {"important" => true,   "fixed" => false},
      "Cantidad solicitada" =>  {"important" => false,  "fixed" => false},
      "Cantidad aprobada" =>    {"important" => false,  "fixed" => false},
      "Especificación" =>       {"important" => false,  "fixed" => false},
      "Acción" =>               {"important" => true,   "fixed" => true}
    }

    def budgeted?
    	budgeted
    end

    def state_point
        {steps: [{title: state_title, description: state_description }]}
    end

    def state_title
    	if budgeted?
    		"Presupuestado"
    	else
    		"Falta presupuestar"
    	end
    end

    def state_description
        if budgeted?
            "Presupuesto en estado #{budget_state}. Se presupuestaron #{budget_quantity} #{product_measurement}."
        else
            "Debe registrar el presupuesto."
        end
    end
end
