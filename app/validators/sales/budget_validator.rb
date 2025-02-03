module BudgetValidator
	extend ActiveSupport::Concern

	included do
		before_validation       		:set_user, if: :new_record?

		validates_presence_of         	:entity_id, message: "El presupuesto debe estar asociado a un cliente"
	    validate                  		:entity_contact_belongs_to_client
	    validate                  		:entity_belongs_to_company
	    validates_length_of       		:delivery_address, maximum: 100, message: "Domicilio de entrega muy largo. Limite 100 caracteres", allow_nil: true
	    validates_presence_of     		:init_date, message: "Debe especificar la fecha del presupuesto"
	    validate                  		:final_date_greater_than_init_date
	    validates_numericality_of 		:discount
	    validates_numericality_of 		:total, greater_than_or_equal_to: 0, less_than_or_equal_to: 999999999
	    validates_presence_of         	:state, message: "Debe especificar un estado"
	    validates_inclusion_of    		:state, in: ExpedientBudget::STATES, message: "Estado inválido"
	    validates_length_of       		:observation, maximum: 1000, message: "Observación demasiado larga."
	    validate                  		:at_least_one_detail
	end

	def set_user
    	self.user_id = current_user.id
  	end

	def entity_contact_belongs_to_client
      errors.add(:entity_contact_id, "El contacto no pertenece al proveedor seleccionado") unless (entity_contact.nil? || entity_contact.entity_id == entity_id)
    end

    def entity_belongs_to_company
      errors.add(:entity_id, "El proveedor no pertenece a su compañía") unless (entity.nil? || entity.company_id == company_id)
    end

    def final_date_greater_than_init_date
      errors.add(:final_date, "La fecha de vencimiento no puede ser menor a la fecha de inicio") unless (self.init_date.blank? || self.final_date.blank? || self.init_date.to_date <= self.final_date.to_date)
    end

    def at_least_one_detail
      errors.add(:base, "Debe especificar por lo menos un detalle") unless details.size > 0
    end
end
