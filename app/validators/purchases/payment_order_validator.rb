module Purchases::PaymentOrderValidator
	extend ActiveSupport::Concern

	included do
		validates_presence_of :supplier, message: "Debe seleccionar un proveedor."
		validates_presence_of :user, message: "Debe estar asociado a un usuario."
		validates_presence_of :state, message: "Debe seleccionar un estado."
		validates_inclusion_of :state, in: Purchases::PaymentOrder::STATES, message: "Estado inválido."
		validates_presence_of :date, message: "Debe seleccionar una fecha"

		validate :total_must_match_with_details
	end

	def total_must_match_with_details
		details.reject(&:marked_for_destruction?).map(&:total).sum().to_f.round(2) == total.to_f.round(2)
	end
end