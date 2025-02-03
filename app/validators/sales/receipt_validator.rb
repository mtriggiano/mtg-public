module ReceiptValidator
	extend ActiveSupport::Concern

	included do
		validates_presence_of     :entity_id, message: "Debe asociar una entidad."
		validates_presence_of     :user_id, 	message: "Debe especificar el responsable."
		validates_presence_of     :total, 		message: "El total no puede estar en blanco"
		validates_numericality_of :total, 		message: "El total solo puede contener caracteres numéricos"
    #validates_length_of       :total, 		message: "El total es demasiado grande. Revise por favor.", maximum: 10
   	validates_presence_of     :state, 		message: "Debe especificar un estado"
    validates_inclusion_of    :state, 		message: "Estado inválido", in: self::STATES
		validates_length_of       :concept, 	message: "Observación demasiado larga.", maximum: 10000

    validate                  :user_belongs_to_company
    validate                  :at_least_one_detail
	end

	def user_belongs_to_company
		errors.add(:user_id, "Usuario incorrecto") unless (user_id.blank? || user.company_id == company_id)
	end

	def at_least_one_detail
		unless receipt_type == "massive"
	    errors.add(:base, "Debe especificar por lo menos un detalle") unless details.reject(&:marked_for_destruction?).size > 0 || !client_payment_order.blank?
		end
	end
end
