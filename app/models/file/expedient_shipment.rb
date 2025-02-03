
class ExpedientShipment < ApplicationRecord
  self.table_name = :shipments
  include Virtus.model(mass_assignment: false, constructor: false)
  include CustomAttributes
  include HasAttachments
  include HasDetails
  include Restricted
  include Reopener
  include StateManager

  TYPES  = ["Traslado + Oficial", "Traslado", "Oficial"]

  include ShipmentValidator
  include TrazabilidadValidator::CantidadesCoinciden
  include TrazabilidadValidator::SinProductosRepetidos
  include TrazabilidadValidator::BatchesSonDelProducto
  include TrazabilidadValidator::CrearBatchPorDefecto

  belongs_to :company
  belongs_to :file, class_name: "Expedient", optional: true
  belongs_to :store, optional: true
  belongs_to :user
  belongs_to :client, foreign_key: :entity_id

  has_many   :orders, through: :file
  has_many   :budgets, through: :file
  has_many   :requests, through: :file
  has_many   :bills, through: :file
  has_many   :receipts, through: :file
  has_many   :responsables, through: :file
  has_one    :location, foreign_key: :shipment_id, inverse_of: :shipment
  has_many   :childs, through: :details
  has_many   :custom_details, class_name: "ExpedientShipmentCustomDetail", dependent: :destroy, foreign_key: :shipment_id
  has_many   :expedient_bill_shipments, foreign_key: :shipment_id
  has_many   :expedient_bills, through: :expedient_bill_shipments

  has_many   :consumption_shipments, foreign_key: :shipment_id, class_name: "Surgeries::ConsumptionShipment"
  has_many   :consumptions, through: :consumption_shipments

  has_many   :all_details, class_name: "ExpedientShipmentDetail", foreign_key: :shipment_id, inverse_of: :shipment

  attribute :current_user, User

  before_validation :set_stock, :set_custom_details

  accepts_nested_attributes_for :location, reject_if: :all_blank
  accepts_nested_attributes_for :custom_details, reject_if: Proc.new{|ca| ca["product_name"].blank? }, allow_destroy: true

  scope :sin_facturas,-> { 
    left_outer_joins(:expedient_bill_shipments).where("bill_shipments.id is null")
  }

  scope :con_facturas,-> { 
    joins(:expedient_bill_shipments).distinct("shipments.id")
  }
  scope :fecha_start,-> (fecha) { where('shipments.date >= ?', (fecha.to_date))}
  scope :fecha_end,-> (fecha) { where('shipments.date <= ?', (fecha.to_date))}

  def self.search(number)
    if !number.blank?
      where("#{table_name}.number ILIKE ?", "%#{number}%")
    else
      all
    end
  end

  def self.search_by_client(client_id)
    unless client_id.blank?
      where(entity_id: client_id)
    else
      all
    end
  end

  def self.search_in_report(band=nil)
    if band.blank?
      all
    else
      if band == "true"
        ids = joins(:expedient_bill_shipments).map(&:id)
        where.not(id: ids)
      else
        all
      end
    end
  end

  def eventos
    return [] if new_record? || from.blank? || to.blank?
    Anmat::EVENTOS[from].select{|obj| obj[:id] == id_evento.to_s}.map{|o| [o[:text], o[:id]]}
  end

  def conformed_file
    super || "/images/attachment.png"
  end

  def set_custom_details
    if custom_details.blank? && approved?
      DetailPdf.new(self, with_childs: shipment_type == "Traslado").build.each do |d|
        cd =  custom_details.build(d.compact.except("type","id", "branch", "source", "price", "bonus_amount", "iva_amount", "total", 'own', 'supplier'))
        cd.type = "ExpedientShipmentCustomDetail"
        cd.custom_detail = true
        cd.save
      end
    end
  end

  def has_batches_with_errors?
    batch_details.map { |b| b.errors.any? }.include?(true)
  end

  def set_stock
    unless store_id.nil?
      transaction do
        #if shipment_type == "Traslado" || shipment_type == "Traslado + Oficial"
        unless (shipment_type == "Oficial" && type == "Surgeries::Shipment")
          pp "entro"
          if need_stock_rollback?
            add_stock
          elsif approved? && state_changed?
            remove_stock
          end
        end
      end
    else
      errors.add(:store_id, "Indique el depósito")
    end
  end

  def need_stock_rollback?
    #["Traslado", "Traslado + Oficial"].include?(shipment_type) && (
      changes[:state] == ["Finalizado", "Pendiente"] ||
      changes[:state] == ["Finalizado", "Anulado"]   ||
      changes[:state] == ["Confirmado", "Pendiente"] ||
      changes[:state] == ["Confirmado", "Anulado"]
    #)
  end

  def add_stock
    details.each do |detail|
      detail.add_stock
      detail.childs.each{ |d| d.add_stock}
    end
  end

  def remove_stock
    details.each {|detail| detail.need_to_remove_stock = true}
  end

  def custom_details_builder
    return custom_details unless custom_details.blank?
    DetailPdf.new(self, with_child: true).build.each do |d|
      custom_details.build(d.compact.except("type", "branch", "source", 'own', 'supplier'))
    end
    return custom_details
  end

  def pdf_name
    "remito_#{number}"
  end


  def used?
    expedient_bills.any?
  end

  def puedo_registrar_entrada?
    self.traslado_stock_interno && self.approved? && self.external_arrival.nil?
  end

end
