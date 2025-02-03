class Sales::Shipment < ExpedientShipment
  belongs_to :client, foreign_key: :entity_id
  include Notificable
  belongs_to :file, class_name: "Sales::File"
  belongs_to :client, foreign_key: :entity_id
  belongs_to :entity

  has_many :shipments_orders, class_name: "Sales::ShipmentOrder", foreign_key: :shipment_id, inverse_of: :shipment

  has_many :orders, through: :shipments_orders
  has_many :order_details, through: :orders, source: :details

  has_many :shipments_bills, class_name: "Sales::BillShipment", foreign_key: :shipment_id, inverse_of: :shipment
  has_many :bills, through: :shipments_bills

  #before_save :send_to_anmat
  #validates_associated :details
  after_save :check_if_order_is_fulfilled


  inherit_details_from :order
  secondary_assign_details_from :bill

  accepts_nested_attributes_for :shipments_orders, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :shipments_bills, reject_if: :all_blank, allow_destroy: true

  default_scope -> {where(type: name)}

  before_validation :at_least_one_order

  def at_least_one_order
    shipments_orders.build if shipments_orders.reject(&:marked_for_destruction?).size == 0
  end

  def department
    "Almacen"
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
        if detail.quantity != detail.orders_details.sum(:quantity)
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
