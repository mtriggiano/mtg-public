class ExpedientBudgetDetail < ApplicationRecord
    self.table_name = :budget_details
	  STATES = ExpedientBudget::STATES

    store_accessor :custom_attributes,
                    :ordered,
                    :order_id
  	include ProductDetails
    scope :approveds, ->{where(state: "Aprobado")}

    before_validation :set_iva_amount

    belongs_to :expedient_budget, foreign_key: :budget_id, optional: true

  	def check_permissions
      if current_user.cannot?(:approve, SaleBudget)
        errors.add(:state, "No posee los permisos necesarios para modificar el estado.") if state_changed?
      end
    end

    def assign_from_another sr_detail, recharge=nil, child=false, supplier_id=nil #sr_detail can be a child too
      super do |b|
        b.product_code 		   = sr_detail.product_code
        b.product_measurement = "Unidad"
        b.discount 			     = -recharge.to_f
        b.description 		   = sr_detail.description
        yield self if block_given?
      end
    end

    def build_child_from_product product
      super do |d|
        d.product_code = product.code
      end
    end

    def set_iva_amount
      self.iva_amount = (((quantity.to_f * price.to_f) * iva.to_f) * (1 - discount/100)).round(4)
    end

    def bonus_amount
      return ((price * quantity) * (discount/100)).round(2)
    end
end
