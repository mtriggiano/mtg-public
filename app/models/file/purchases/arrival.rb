class Purchases::Arrival < ExpedientArrival
  belongs_to :file, class_name: 'Purchases::File', foreign_key: :file_id
  belongs_to :supplier, class_name: 'Supplier', foreign_key: :entity_id
  include Notificable

  has_many   :arrivals_orders, class_name: 'Purchases::ArrivalsOrder',dependent: :destroy, inverse_of: :arrival
  has_many   :purchase_orders, class_name: "Purchases::Order", through: :arrivals_orders, source: :order
  has_many   :devolutions_arrivals, class_name: 'Purchases::DevolutionsArrival',dependent: :destroy, inverse_of: :arrival
  has_many   :budgets, through: :file
  has_many   :orders, through: :file
  has_many   :arrivals, through: :file
  has_many   :returns, through: :file
  has_many   :bills, through: :file
  has_many   :devolutions, through: :file

  has_many   :batches,    through: :details

  accepts_nested_attributes_for :batches, reject_if: Proc.new{|batch| batch.try(:code).blank?}, allow_destroy: true
  accepts_nested_attributes_for :arrivals_orders, allow_destroy: true, reject_if: :all_blank

  inherit_details_from :order
  before_validation :at_least_one_order
  after_save :check_if_order_is_fulfilled

  validates_presence_of :arrivals_orders, message: "Debe asociar al menos una orden de compra"

  def department
    "Almacen"
  end

  def at_least_one_order
    arrivals_orders.build if arrivals_orders.reject(&:marked_for_destruction?).size == 0
  end

  def details_attributes=(attrs)
    attrs.each do |_, det|
      det["entity_id"] = entity_id
    end
    super
  end

  def childs_attributes=(attrs)
    attrs.each do |_, det|
      det["entity_id"] = entity_id
    end
    super
  end

  def check_if_order_is_fulfilled
    if saved_change_to_state? && confirmed?
      details.each do |detail|
        if detail.quantity != detail.purchase_order_details.sum(:quantity)
          manager = company.departments.find_by_name("Compras").try(:user_id)
          Notification::Purchases::Arrival.new(self, current_user, [manager]).for_not_matching
          break
        end
      end
    end
  end

  def has_pdf?
    false
  end

end
