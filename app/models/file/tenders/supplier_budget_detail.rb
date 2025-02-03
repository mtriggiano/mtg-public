class Tenders::SupplierBudgetDetail < ExpedientBudgetDetail
  self.abstract_stock = true
    belongs_to :budget, foreign_key: :budget_id, inverse_of: :details, optional: true


    store_accessor :custom_attributes, :ordered, :order_detail_id, :order_state,
                                       :order_quantity, :product_brand, :supplier_name, :cost

    TABLE_COLUMNS = {
        "Número"            => {"important" => true, "fixed" => true},
        "Tipo"              => {"important" => false, "fixed" => false},
        "Producto"          => {"important" => true,  "fixed" => false},
        "PM"            => {"important" => true, "fixed" => false},
        "Marca"            => {"important" => false, "fixed" => false},
        "Proveedor"            => {"important" => false, "fixed" => false},
        "Cantidad"          => {"important" => true,  "fixed" => false},
        #"Unidad de medida"  => {"important" => false, "fixed" => false},
        "Costo"             => {"important" => true,  "fixed" => false},
        "Margen"     => {"important" => false, "fixed" => false},
        "Precio"       => {"important" => true,  "fixed" => false},
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
