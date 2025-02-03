module PurchaseRequestValidator
	extend ActiveSupport::Concern

	included do

	    validates_presence_of   :user_id, message: "Debe seleccionar que usuario fue el que genero la solicitud"
	    validates_inclusion_of  :request_type, in: PurchaseRequest::TYPES, message: "Motivo inválido"
	    validates_presence_of   :date, message: "La fecha de inicio no puede estar en blanco"
	    validate                :due_date_greater_than_date, if: :due_date_changed?
	    validates_inclusion_of  :urgency_level, in: 1..10, message: "Nivel de urgencia inválido"
	    validates_inclusion_of  :state, in: PurchaseRequest::STATES, message: "Estado inválido"
	    validates_length_of     :observation, maximum: 1000, message: "Observación demasiado larga."
	    validate                :at_least_one_detail
	    validate                :date_greater_than_today, if: :date_changed?
	    validate                :due_date_greater_than_date, if: :due_date_changed?
	end


  	def date_greater_than_today
      	errors.add(:date, "La fecha no puede ser menor a #{I18n.l(Date.today, format: :short)}") unless (self.date.blank? || self.date.to_date >= Date.today)
    end

    def due_date_greater_than_date
      	errors.add(:due_date, "La fecha de vencimiento no puede ser menor a la fecha de inicio") unless (self.date.blank? || self.due_date.blank? || self.date.to_date <= self.due_date.to_date)
    end
end