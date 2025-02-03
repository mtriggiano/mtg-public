class Purchases::BudgetDetail < ExpedientBudgetDetail
    include ProductInheritance
	belongs_to :budget, foreign_key: :budget_id, inverse_of: :details, optional: true

    TABLE_COLUMNS = {
        "Número"            => {"important" => false,  "fixed" => false},
        "⚫"                => {"important" => false,  "fixed" => false},
        "Producto"          => {"important" => true,  "fixed" => false},
        "Código"            => {"important" => true, "fixed" => false},
        "Marca"             => {"important" => true, "fixed" => false},
        "Cantidad"          => {"important" => true,  "fixed" => false},
        "Precio p/unidad"   => {"important" => true,  "fixed" => false},
        "Descuento (%)"     => {"important" => false, "fixed" => false},
        "I.V.A.(%)"         => {"important" => true,  "fixed" => false},
        "Subtotal ($)"      => {"important" => true,  "fixed" => true},
        "Acción"            => {"important" => true,  "fixed" => true}
    }

    def ordered?
        ordered
    end

    def assign_from_another sr_detail, recharge=nil, child=false, supplier_id=nil #sr_detail can be a child too
        super do |o|
            o.quantity += sr_detail.approved_quantity.to_i - sr_detail.budget_quantity.to_i
            o.mark_for_destruction unless o.quantity > 0
        end
    end

    def state_point
        steps = {steps: [{title: state_title, description: state_description}]}
    end

    def state_title
        if ordered
            "Asignado a una orden de compra"
        else
            "Sin orden de compra asignada"
        end
    end

    def state_description
        if ordered
            "El detalle fue asignado a una orden de compra con estado #{order_state}. Se asociaron un total de #{order_quantity} #{product_measurement}"
        else
            "Aún no se asigno ninguna orden de compra a este detalle."
        end
    end
end
