class Tenders::BudgetDetail < ExpedientBudgetDetail
    belongs_to :budget, foreign_key: :budget_id, inverse_of: :details, optional: true


    store_accessor :custom_attributes, :ordered, :order_detail_id, :order_state,
                                       :order_quantity

    TABLE_COLUMNS = {
        "⚫"                => {"important" => false, "fixed" => false},
        "Tipo"              => {"important" => false, "fixed" => false},
        "Producto"          => {"important" => true,  "fixed" => false},
        "Código"            => {"important" => true, "fixed" => false},
        "Cantidad"          => {"important" => true,  "fixed" => false},
        #"Unidad de medida"  => {"important" => false, "fixed" => false},
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
        if ordered
            "El detalle fue asignado a una orden de venta con estado #{order_state}. Se asociaron un total de #{order_quantity} #{product_measurement}"
        else
            "Aún no se asigno ninguna orden de venta a este detalle."
        end
    end
end
