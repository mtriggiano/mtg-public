module PurchaseOrderValidator
	extend ActiveSupport::Concern

	included do
    before_validation         :set_subtotal, :set_discount, :set_total
    validates_presence_of     :supplier_id, message: "Debe asociar un proveedor con la orden"
    validates_presence_of     :user_id, message: "Debe especificar quien fue el encargado de generar la orden"
    validates_presence_of     :subtotal, message: "El subtotal no puede estar en blanco"
    validates_numericality_of :subtotal, message: "El subtotal solo puede contener caracteres numéricos"
    validates_length_of       :subtotal, maximum: 10, message: "El subtotal es demasiado grande. Revise por favor."
    validates_numericality_of :discount, message: "El descuento solo puede contener caracteres numéricos", allow_blank: true
    validates_length_of       :discount, maximum: 10, message: "El descuento es demasiado grande. Revise por favor.", allow_blank: true
    validates_presence_of     :total, message: "El total no puede estar en blanco"
    validates_numericality_of :total, message: "El total solo puede contener caracteres numéricos"
    validates_length_of       :total, maximum: 10, message: "El total es demasiado grande. Revise por favor."
    validates_presence_of     :shipping_price, message: "Debe especificar un costo de envío", if: :shipping_included
    validates_numericality_of :shipping_price, message: "Costo de envío inválido", if: :shipping_included
    validates_length_of       :shipping_price, maximum: 20, message: "Costo de envio demasiado grande. Revise por favor.", if: :shipping_included
    validates_presence_of     :state, message: "Debe especificar un estado"
    validates_inclusion_of    :state, in: PurchaseOrder::STATES, message: "Estado inválido"
  	validates_length_of       :observation, maximum: 1000, message: "Observación demasiado larga."
  	validate                  :supplier_belongs_to_company
  	validate                  :user_belongs_to_company
  	validate                  :expected_delivery_date_greater_than_today
	end

  def set_subtotal
    subtotal = details.reject(&:marked_for_destruction?).map{|detail| detail.quantity * detail.price * (1 + detail.iva)}.sum().to_f.round(2)
  end

  def set_discount
    discount = details.reject(&:marked_for_destruction?).map{|detail| (detail.quantity * detail.price * (1 + detail.iva)) * (detail.discount / 100)}.sum().to_f.round(2)
  end

  def set_total
    total = details.reject(&:marked_for_destruction?).map{|detail| (detail.quantity * detail.price * (1 + detail.iva)) * (1 - detail.discount / 100)}.sum().to_f.round(2)
  end

  def supplier_belongs_to_company
      errors.add(:supplier_id, "Proveedor incorrecto") unless (supplier_id.blank? || supplier.company_id == company_id)
  end

  def user_belongs_to_company
      errors.add(:user_id, "Usuario incorrecto") unless (user_id.blank? || user.company_id == company_id)
  end

  def expected_delivery_date_greater_than_today
      if expected_delivery_date_changed?
        	errors.add(:expected_delivery_date, "La fecha de entrega debe no puede ser menor a #{I18n.l(Date.today, format: :short)}") unless (expected_delivery_date.blank? || expected_delivery_date.to_date >= Date.today)
      end
  end

end