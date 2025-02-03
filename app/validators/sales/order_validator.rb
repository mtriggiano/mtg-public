module OrderValidator
	extend ActiveSupport::Concern

	included do
		before_validation :set_subtotal, :set_discount, :set_total

	    validates_presence_of     :entity_id, 	message: "Debe asociar un proveedor con la orden"
	    validates_presence_of     :user_id, 	message: "Debe especificar quien fue el encargado de generar la orden"
	    validates_presence_of     :subtotal, 	message: "El subtotal no puede estar en blanco"
	    validates_numericality_of :subtotal, 	message: "El subtotal solo puede contener caracteres numéricos"
	    validates_length_of       :subtotal, 	message: "El subtotal es demasiado grande. Revise por favor.", maximum: 10
	    validates_numericality_of :discount, 	message: "El descuento solo puede contener caracteres numéricos", allow_blank: true
	    validates_length_of       :discount, 	message: "El descuento es demasiado grande. Revise por favor.", allow_blank: true, maximum: 10
	    validates_presence_of     :total, 		message: "El total no puede estar en blanco", maximum: 10
	    validates_numericality_of :total, 		message: "El total solo puede contener caracteres numéricos"
	    validates_length_of       :total, 		message: "El total es demasiado grande. Revise por favor.", maximum: 10
	    validates_presence_of     :state, 		message: "Debe especificar un estado"
	    validates_inclusion_of    :state, 		message: "Estado inválido", in: self::STATES
		validates_presence_of	  :order_type,  message: "Debe especificar un tipo"
	    validates_length_of       :observation, message: "Observación demasiado larga.", maximum: 10000
		validate                  :check_order_type
	    validate                  :user_belongs_to_company
	    validate                  :expected_delivery_date_greater_than_today
	end

	def set_subtotal
		subtotal = details.reject(&:marked_for_destruction?).map{|detail| detail.quantity.to_f * detail.price.to_f * (1 + detail.iva.to_f)}.sum().to_f.round(2)
	end

	def set_discount
		discount = details.reject(&:marked_for_destruction?).map{|detail| (detail.quantity.to_f * detail.price.to_f * (1 + detail.iva.to_f)) * (detail.discount.to_f / 100)}.sum().to_f.round(2)
	end

	def set_total
		total = details.reject(&:marked_for_destruction?).map{|detail| (detail.quantity.to_f * detail.price.to_f * (1 + detail.iva.to_f)) * (1 - detail.discount.to_f / 100)}.sum().to_f.round(2)
	end

	def check_order_type
    	errors.add(:order_type, "Tipo de orden inválida") unless self.class::TYPES.include?(order_type)
	end

	def user_belongs_to_company
		errors.add(:user_id, "Usuario incorrecto") unless (user_id.blank? || user.company_id == company_id)
	end

	def expected_delivery_date_greater_than_today
		errors.add(:expected_delivery_date, "La fecha de entrega debe no puede ser menor a #{I18n.l(Date.today, format: :short)}") unless (expected_delivery_date.blank? || expected_delivery_date.to_date >= Date.today || persisted?)
	end

	private
		def details_subtotal
			details_subtotal = details.reject(&:marked_for_destruction?).map(&:total).sum().to_f.round(2)
		end
end
