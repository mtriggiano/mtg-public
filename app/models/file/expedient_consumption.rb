# frozen_string_literal: true

class ExpedientConsumption < ApplicationRecord
  self.table_name = :shipments
  include Virtus.model(mass_assignment: false, constructor: false)
  include CustomAttributes
  include HasAttachments
  include HasDetails
  include Restricted
  include Reopener
  include Numerable
  include StateManager

  include TrazabilidadValidator::CantidadesCoinciden
  include TrazabilidadValidator::SinProductosRepetidos
  include TrazabilidadValidator::BatchesSonDelProducto
  include TrazabilidadValidator::CrearBatchPorDefecto

  belongs_to :company
  belongs_to :file, class_name: 'Expedient', foreign_key: :file_id
  belongs_to :store
  belongs_to :entity
  belongs_to :user, optional: true

  has_many   :expedient_sale_order_consumptions, foreign_key: :shipment_id
  has_many   :sale_orders, through: :expedient_sale_order_consumptions, source: :sale_order
  has_many   :expedient_purchase_order_consumptions, foreign_key: :shipment_id
  has_many   :purchase_orders, through: :expedient_purchase_order_consumptions, source: :purchase_order

  has_many   :responsables, through: :file
  attribute  :current_user, User

  TYPES         = ['Consumo'].freeze

  def self.search(number)
    if !number.blank?
      where("#{table_name}.number ILIKE ?", "%#{number}%")
    else
      all
    end
  end

  def pdf_name
    "consumo_#{number}"
  end
end
