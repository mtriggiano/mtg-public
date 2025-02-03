class Surgeries::Arrival < ExpedientArrival
  include Notificable
  belongs_to :file, class_name: "Surgeries::File", foreign_key: "file_id"
  belongs_to :supplier, foreign_key: :entity_id

  has_many :arrivals_purchase_requests, dependent: :destroy, class_name: "Surgeries::ArrivalPurchaseRequest", foreign_key: :arrival_id, inverse_of: :arrival
  has_many :purchase_requests, through: :arrivals_purchase_requests
  has_many :supplier_bill_arrivals, class_name: "Surgeries::SupplierBillArrival", source: :arrival, inverse_of: :arrival
  has_many :supplier_bills, through: :supplier_bill_arrivals
  after_save :merge_with_request

  validates_presence_of :arrivals_purchase_requests, message: 'Debe asociar al menos un pedido de compra'

  inherit_details_from :purchase_request

  accepts_nested_attributes_for :arrivals_purchase_requests, reject_if: :all_blank, allow_destroy: true
  before_validation :at_least_one_request
  after_save :check_if_request_is_fulfilled, :check_shipment_stock

  def department
    "Almacen"
  end

  def check_shipment_stock
    if saved_change_to_state? && approved?
      file.shipments.each{|s| s.details.each(&:check_stock); s.childs.each(&:check_stock)}
    end
  end

  def at_least_one_request
    arrivals_purchase_requests.build if arrivals_purchase_requests.size == 0
  end

  def merge_with_request
    details.each{|detail| detail.merge_with_request}
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

  def check_if_request_is_fulfilled
    if saved_change_to_state? && confirmed?
      details.each do |detail|
        if detail.quantity != detail.purchase_request_details.sum(:quantity)
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
