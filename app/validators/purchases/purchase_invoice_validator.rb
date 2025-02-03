module PurchaseInvoiceValidator
	extend ActiveSupport::Concern
  included do
    before_validation         :set_user

    validates_presence_of     :file, message: "La factura debe estar asociada a un expediente"
    validates_length_of       :cbte_num, maximum: 20, message: "El número de comprobante es demasiado largo. Máximo 20 caracteres.", if: :confirmed?
    validates_presence_of     :cbte_num, message: 'El numero de comprobante no puede estar vacio', if: :confirmed?
    validates_presence_of     :cbte_tipo, message: 'El tipo de comprobante no puede estar en blanco'

    validates_presence_of     :user_id, message: "Debe especificar quien fue el encargado de generar la orden"
    validate                  :user_belongs_to_company

    validates_presence_of     :iva_amount, message: "El monto de IVA no puede estar en blanco", if: :is_factura_a?
    validates_numericality_of :iva_amount, message: "El monto de IVA solo puede contener caracteres numéricos", if: :is_factura_a?

    validates_presence_of     :cbte_fecha, message: 'La fecha de comprobante no puede estar en blanco'
    #validates_presence_of     :due_date, message: 'La fecha de vencimiento no puede estar en blanco'

    validates_presence_of     :total, message: "El total no puede estar en blanco"
    validates_numericality_of :total, message: "El total solo puede contener caracteres numéricos"

    validates_presence_of     :gross_amount, message: "El monto neto no puede estar en blanco"
    validates_numericality_of :gross_amount, message: "Monto neto inválido"

    validates_presence_of     :state, message: "Debe especificar un estado"
    validates_inclusion_of    :state, in: Purchases::Bill::STATES, message: "Estado inválido"
    validates_length_of       :observation, maximum: 1000, message: "Observación demasiado larga."
    validate                  :same_supplier_in_arrival_note
  end

  def set_user
    self.user_id = current_user.id
  end

  def same_supplier_in_arrival_note
    if purchase_arrival_id_changed?
      errors.add(:purchase_arrival_id, "El proveedor del remito no coincide con el proveedor del comprobante.") unless purchase_arrival.supplier_id == supplier_id
    end
  end

  def user_belongs_to_company
    errors.add(:user_id, "Usuario incorrecto") unless (user_id.blank? || user.company_id == company_id)
  end

end
