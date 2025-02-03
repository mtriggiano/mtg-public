class Surgeries::Consumption < ExpedientConsumption
  include Notificable
  belongs_to :file, class_name: "Surgeries::File"
  belongs_to :client, foreign_key: :entity_id
  inherit_details_from :shipment
  has_many :consumptions_shipments,
            class_name: "Surgeries::ConsumptionShipment",
            foreign_key: :consumption_id,
            inverse_of: :consumption
  has_many :shipments, through: :consumptions_shipments, source: :shipment
  has_many :shipment_details, through: :shipments, source: :details
  #has_many :childs, through: :details
  validates_associated :details, :childs
  accepts_nested_attributes_for :consumptions_shipments, reject_if: :all_blank, allow_destroy: true
  before_validation :set_consumption_shipment_if_empty
  before_validation :set_consumption, :unset_consumption
  default_scope -> {where(type: name)}

  def department
    "Ventas"
  end

  def set_consumption_shipment_if_empty
    consumptions_shipments.build if consumptions_shipments.reject(&:marked_for_destruction?).size == 0
  end

  def set_consumption
    transaction do
      if confirmed? && state_changed?
        details.each do |detail|
          if detail.quantity > 0
            detail.set_consumption
          else
            detail.delay.set_consumption
          end
        end
      end
    end
  end

  def need_stock_rollback?
    changes[:state] == ["Finalizado", "Pendiente"] ||
    changes[:state] == ["Finalizado", "Anulado"]   ||
    changes[:state] == ["Confirmado", "Pendiente"] ||
    changes[:state] == ["Confirmado", "Anulado"]
  end

  def unset_consumption
    transaction do
      if need_stock_rollback?
        details.each{|detail| detail.need_to_remove_stock = true }
      end
    end
  end

  def has_pdf?
    true
  end

  def to_s
		"Consumo Nº #{number}"
	end

  def devolution
    devolutions = []
    details.select{|d| !d.inventary.own}.group_by(&:entity_id).each do |supplier_id, supplier_details|
      unless supplier_id.blank?
        dev = Surgeries::Consumption.new(self.attributes)
        dev.id = nil
        dev.details.reload
        supplier_details.each do |detail|
          detail.quantity = detail.sended_quantity - detail.quantity
          d = dev.details.build(detail.attributes)
          detail.childs.each do |c|
            c.quantity = c.sended_quantity - c.quantity
            d.childs.build(c.attributes)
          end
        end
        devolutions << [supplier_id, dev]
      end
    end
    return devolutions
  end

end
