module PurchaseReturnValidator
	extend ActiveSupport::Concern

	included do
		validates_presence_of     :purchase_file_id, message: "La devolución de productos debe estar asociada a un expediente"
		validates_length_of       :number, maximum: 20, message: "El número del orden es demasiado largo. Máximo 20 caracteres."
		validates_uniqueness_of   :number, scope: [:company_id, :active], message: "El número de orden ya existe"
		validates_presence_of     :supplier_id, message: "Debe asociar un proveedor con la orden"
		validates_presence_of     :user_id, message: "Debe especificar quien fue el encargado de generar la orden"
		validates_presence_of     :state, message: "Debe especificar un estado"
		validates_inclusion_of    :state, in: PurchaseReturn::STATES, message: "Estado inválido"
		validates_length_of       :observation, maximum: 1000, message: "Observación demasiado larga."
		validate                  :at_least_one_detail
		validate                  :user_belongs_to_company
		validate                  :expected_date_greater_than_today
		validate                  :supplier_belongs_to_company
		validate 				  :gtins_must_be_availables
	end

	 def user_belongs_to_company
	    errors.add(:user_id, "Usuario incorrecto") unless (user_id.blank? || user.company_id == company_id)
	end

	def supplier_belongs_to_company
	    errors.add(:supplier_id, "Proveedor incorrecto") unless (supplier_id.blank? || supplier.company_id == company_id)
	end


	def expected_date_greater_than_today
	    errors.add(:date, "La fecha de entrega debe no puede ser menor a #{I18n.l(Date.today, format: :short)}") unless (date.blank? || date.to_date <= Date.today)
	end

	def at_least_one_detail
	    errors.add(:base, "Debe especificar por lo menos un detalle") unless details.reject(&:marked_for_destruction?).size > 0
	end

	def gtins_must_be_availables
		unit_gtins.each{|g| errors.add(:base, "El G.T.I.N. #{g.gtin} no esta disponible.") unless g.is_available?}
	end
end 