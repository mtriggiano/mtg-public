# frozen_string_literal: true

module ArrivalValidator
  extend ActiveSupport::Concern

  included do
    before_validation :set_user

		validates_length_of 			:number, :minimum => 3, :message => "Debe contener al menos 3 caracteres"
		validate 									:uniqueness_of_number
    validates_presence_of     :user_id, message: 'Debe especificar quien fue el encargado de generar la orden'
    validates_presence_of     :store_id, message: 'Debe especificar el depósito receptor'
    validates_presence_of     :date, message: 'Debe especificar la fecha de llegada'
    validates_presence_of     :punctuation, message: 'Debe asignar una calificacion al proveedor del remito'
    validates_inclusion_of    :punctuation, in: 1..10, message: 'Puntuación inválida'
    validates_presence_of     :state, message: 'Debe especificar un estado'
    validates_inclusion_of    :state, in: self::STATES, message: 'Estado inválido'
    validates_length_of       :observation, maximum: 1000, message: 'Observación demasiado larga.'
    validate                  :user_belongs_to_company
    validate                  :store_belongs_to_company
  end

  def user_belongs_to_company
    unless user_id.blank? || user.company_id == company_id
      errors.add(:user_id, 'Usuario incorrecto')
    end
  end

  def store_belongs_to_company
    unless store_id.blank? || store.company_id == company_id
      errors.add(:store_id, 'Depósito incorrecto')
    end
  end

  def set_user
    self.user_id = current_user.id
  end

  def set_order
		if type.deconstantize == "Surgeries"
			arrivals_purchase_requests.build if arrivals_purchase_requests.empty?
    elsif type.deconstantize == ""
      external_arrivals_expedient_requests.build if external_arrivals_expedient_requests.empty?
		else
    	arrivals_orders.build if arrivals_orders.empty?
		end
  end

	def active_and_change
		active && number_changed?
	end

	def uniqueness_of_number
		if active_and_change
			errors.add(:base, "El número de remito ya fue cargado.") if self.class.where(company_id: company_id, active: true, state: ["Pendiente", "Aprobado", "Finalizado", "Confirmado", "En revisión"]).pluck(:number).include?(number)
		end
	end
end
