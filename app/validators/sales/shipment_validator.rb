module ShipmentValidator
  extend ActiveSupport::Concern

  included do
    before_validation :set_user

    validates_presence_of 	  :file_id, message: 'El remito debe estar asociado a un expediente', if: proc { |s| s.surgery_file_id.blank? && s.type != "ExternalShipment" }
    validates_presence_of     :number, message: 'Debe especificar un número de remito', if: :approved?
    validates_length_of       :number, maximum: 20, message: 'El número del remito es demasiado largo. Máximo 20 caracteres.', if: :approved?
    validates_length_of       :number, minimum: 3, message: 'El número del remito es demasiado corto. Mínimo 3 caracteres.', if: :approved?
    validates_uniqueness_of   :number, scope: %i[company_id active shipment_type], message: 'El número de remito ya existe', if: :approved?
    validates_presence_of     :date, message: 'Debe especificar la fecha del remito'
    validates_inclusion_of    :state, in: self::STATES, message: 'Estado inválido'
    validates_length_of       :observation, maximum: 1000, message: 'Observación demasiado larga.'
    validate                  :client_belongs_to_company
    validates_presence_of     :client, message: 'Debe asociar un cliente'
    #validates_presence_of     :store, message: 'Debe asociar un depósito'
    validates_presence_of     :user, message: 'Debe asociar un usuario'
    before_validation :set_conformed_data

  end

  def client_belongs_to_company
    unless entity_id.blank? || client.company_id == company_id
      errors.add(:entity_id, 'El cliente no pertenece a su compañía')
   end
    end

  def set_user
    self.user_id = current_user.id
  end

  def set_conformed_data
    if conformed
      self.conformed_by = current_user.id
      self.conformed_at = Time.now
    end
  end
end
