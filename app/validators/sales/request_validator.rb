module RequestValidator
	extend ActiveSupport::Concern

	included do
		before_validation       :set_user, if: :new_record?
		before_validation       :set_childs_current_user
    validates_presence_of   :number, message: "La solicitud debe tener un número asociado"
    validates_presence_of   :request_type, message: "Debe especificar el tipo de solicitud"
    validates_presence_of   :user_id, message: "Debe seleccionar que usuario fue el que genero la solicitud"
    validate                :request_type_inclusion
    validate                :date_greater_than_today
    validates_presence_of   :init_date, message: "La fecha de inicio no puede estar en blanco"
    validates_presence_of   :urgency, message: "Debe indicar el nivel de urgencia de la solicitud"
    validate                :init_date_greater_than_date
    validates_inclusion_of  :urgency, in: 1..10, message: "Nivel de urgencia inválido"
    validates_inclusion_of  :state, in: ExpedientRequest::STATES, message: "Estado inválido"
    validates_presence_of   :state, message: "El estado no puede estar en blanco"
    validate                :at_least_one_detail
    validate                :check_permissions
	end

  def set_user
    self.user_id = current_user.id
  end

	def set_childs_current_user
    details.reject(&:marked_for_destruction?).each{ |detail| detail.current_user = self.current_user }
  end

  def request_type_inclusion
    self.class::TYPES.include?(request_type)
  end

  def date_greater_than_today
    	errors.add(:init_date, "La fecha no puede ser menor a #{I18n.l(Date.today, format: :short)}") unless (self.init_date.blank? || self.init_date.to_date >= Date.today || !self.init_date_changed?)
  end

  def init_date_greater_than_date
    	errors.add(:init_date, "La fecha de vencimiento no puede ser menor a la fecha de inicio") unless (self.init_date.blank? || self.init_date.to_date <= self.final_date.to_date || !self.final_date_changed?)
  end

  def at_least_one_detail
      details.build.errors.add(:product_id, "Debe especificar por lo menos un detalle") unless details.reject(&:marked_for_destruction?).size > 0
  end

  def check_permissions
    	errors.add(:state, "No puede actualizar el estado de la solicitud, no posee los permisos necesarios.") if current_user.cannot?(:approve, self) && state_changed?
  end

end
