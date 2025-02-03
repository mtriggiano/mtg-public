class Tenders::Shipment < ExpedientShipment
  belongs_to :client, foreign_key: :entity_id
  include Notificable
  belongs_to :file, class_name: "Tenders::File"
  belongs_to :client, foreign_key: :entity_id
  belongs_to :entity

  has_many :shipments_orders, class_name: "Tenders::ShipmentOrder", foreign_key: :shipment_id, inverse_of: :shipment
  has_many :orders, through: :shipments_orders
  has_many :order_details, through: :orders, source: :details
  has_many :details, class_name: "Tenders::ShipmentDetail", foreign_key: :shipment_id
  before_save :send_to_anmat
  validates_associated :details
  after_save :merge_with_order, :check_if_order_is_fulfilled


  inherit_details_from :order
  accepts_nested_attributes_for :shipments_orders, reject_if: :all_blank, allow_destroy: true

  validates_presence_of :shipments_orders, message: "Debe asociar al menos una orden"

  default_scope -> {where(type: name)}

  before_validation :at_least_one_order

    def at_least_one_order
        shipments_orders.build if shipments_orders.reject(&:marked_for_destruction?).size == 0
    end

  def department
    "Almacen"
  end


  def merge_with_order
    details.each{|detail| detail.merge_with_order}
  end

  def send_to_anmat
    if confirmed? && state_changed?
      Anmat::Shipment.new(shipment: self).send_medicamentos
      if errors.any?
        restore_state!
        raise ActiveRecord::RecordInvalid.new(self)
      end
    end
  end

  def check_if_order_is_fulfilled
    if saved_change_to_state? && confirmed?
      details.each do |detail|
        if detail.quantity != detail.order_details.sum(:quantity)
          manager = company.departments.find_by_name("Ventas").try(:user_id)
          Notification::Sales::Shipment.new(self, current_user, [manager]).for_not_matching
          break
        end
      end
    end
  end

  def has_pdf?
    true
  end

  def delivery_place
    file.try(:place) || "Sin especificar"
  end
end
