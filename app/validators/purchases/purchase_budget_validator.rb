module PurchaseBudgetValidator
	extend ActiveSupport::Concern

	included do
    before_validation         :set_user
		validates_presence_of     :purchase_file_id, message: "El presupuesto debe estar asociado a un expediente"
    validates_presence_of     :number, message: "Debe especificar un número de presupuesto"
    validates_length_of       :number, maximum: 20, message: "El número del presupuesto es demasiado largo. Máximo 20 caracteres."
    validates_length_of       :number, minimum: 3, message: "El número del presupuesto es demasiado corto. Mínimo 3 caracteres."
    validates_uniqueness_of   :number, scope: [:company_id, :active], message: "El número de presupuesto ya existe"
    validates_length_of       :delivery_address, maximum: 100, message: "Domicilio de entrega muy largo. Limite 100 caracteres", allow_nil: true
    validates_presence_of     :date, message: "Debe especificar la fecha del presupuesto"
    validates_numericality_of :total, greater_than_or_equal_to: 0, less_than_or_equal_to: 999999999
    validates_inclusion_of    :state, in: PurchaseBudget::STATES, message: "Estado inválido"
    validates_length_of       :observation, maximum: 1000, message: "Observación demasiado larga."
    validate                  :supplier_contact_belongs_to_supplier
    validate                  :supplier_belongs_to_company
    validate                  :due_date_greater_than_date
    validate 				  :total_must_match_with_details
    validate 				  :discount_must_match_with_details
	end
	
	def set_user
		self.user_id = current_user.id
	end

  def set_user
    self.user_id = current_user.id
  end

	def supplier_contact_belongs_to_supplier
      	unless supplier_contact_id.blank?
        	errors.add(:supplier_contact_id, "El contacto no pertenece al proveedor seleccionado") if (supplier_contact.nil? || supplier_contact.supplier_id != supplier_id)
     	end
    end

    def supplier_belongs_to_company
      	errors.add(:suppliert_id, "El proveedor no pertenece a su compañía") unless (supplier_id.blank? || supplier.company_id == company_id)
    end

    def due_date_greater_than_date
      	errors.add(:due_date, "La fecha de vencimiento no puede ser menor a la fecha de inicio") unless (self.due_date.blank? || self.date.to_date <= self.due_date.to_date)
    end

    def discount_must_match_with_details
        errors.add(:discount, "El descuento no coincide con lo especificado en el/los detalles") unless details_discount == discount
    end

    def total_must_match_with_details
        errors.add(:total, "El total no coincide con lo especificado en el/los detalles") unless total == details_subtotal
    end

    private
  		def details_subtotal
  			details.reject(&:marked_for_destruction?).map(&:total).sum().to_f.round(2)
  		end

  		def details_discount
  			details.reject(&:marked_for_destruction?).map{|d| (d.quantity * d.price * ( 1 + d.iva)) - d.total }.sum().to_f.round(2)
  		end
end