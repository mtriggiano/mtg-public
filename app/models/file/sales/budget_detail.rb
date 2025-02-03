class Sales::BudgetDetail < ExpedientBudgetDetail
    belongs_to :budget, foreign_key: :budget_id, inverse_of: :details, optional: true
    include ProductInheritance


    TABLE_COLUMNS = {
        "Número"            => {"important" => false, "fixed" => false},
        "⚫"                => {"important" => false,  "fixed" => false},
        "Oferta"            => {"important" => false,  "fixed" => false},
        "Tipo"            => {"important" => false,  "fixed" => false},
        "Producto"          => {"important" => true,  "fixed" => false},
        "Código"            => {"important" => true, "fixed" => false},
        "Marca"            => {"important" => true, "fixed" => false},
        "Cantidad"          => {"important" => true,  "fixed" => false},
        "Precio p/unidad"   => {"important" => true,  "fixed" => false},
        "Descuento (%)"     => {"important" => false, "fixed" => false},
        "I.V.A.(%)"         => {"important" => true,  "fixed" => false},
        "Observación"       => {"important" => true,  "fixed" => false},
        "Subtotal ($)"      => {"important" => true,  "fixed" => true},
        "Acción"            => {"important" => true,  "fixed" => true}
    }

    def ordered?
        ordered
    end

    def assign_from_another(so_detail, recharge = 0.0, child = false, supplier_id = nil)
        super do |d|
            pp so_detail.try(:index)
            d.quantity += so_detail.approved_quantity - so_detail.budget_quantity.to_i
            d.mark_for_destruction if d.quantity == 0
        end
    end

    def state_point
        steps = {steps: [{title: state_title, description: state_description}]}
    end

    def state_title
        if ordered
            "Asignado a una orden de venta"
        else
            "Sin orden de venta asignada"
        end
    end

    def state_description
        if ordered?
            "El detalle fue asignado a una orden de venta con estado #{order_state}. Se asociaron un total de #{order_quantity} #{product_measurement}"
        else
            "Aún no se asigno ninguna orden de venta a este detalle."
        end
    end
end
