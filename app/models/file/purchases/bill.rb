class Purchases::Bill < ExpedientBill
  belongs_to :file, class_name: 'Purchases::File', foreign_key: :file_id
  belongs_to :supplier, class_name: "Supplier", foreign_key: :entity_id

  has_many   :bills_orders, class_name: 'Purchases::BillsOrder',dependent: :destroy, inverse_of: :bill
  has_many   :bills_arrivals, class_name: 'Purchases::BillArrival',dependent: :destroy, inverse_of: :bill
  has_many   :purchase_orders, class_name: "Purchases::Order", through: :bills_orders, source: :order
  has_many   :budgets, through: :file
  has_many   :orders, through: :file
  has_many   :returns, through: :file
  has_many   :bills, through: :file
  has_many   :devolutions, through: :file
  has_many   :arrivals, through: :bills_arrivals
  #has_many   :arrival_details, through: :arrivals, source: :details
  has_many   :product_details, class_name: "Purchases::BillInventary", foreign_key: :bill_id, inverse_of: :bill
  has_many   :service_details, class_name: "Purchases::BillService", foreign_key: :bill_id, inverse_of: :bill
  inherit_details_from :order
  filter_details_from :arrival

  accepts_nested_attributes_for :bills_orders, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :bills_arrivals, allow_destroy: true, reject_if: :all_blank
  validates_presence_of :bills_orders, message: "Debe asociar al menos una orden de compra", if: Proc.new{|o| is?(:bill)}

  default_scope { where(flow: "discharge") }

  before_validation :at_least_one_order

  validates_presence_of :sale_point, message: "Debe especificar el punto de venta"

  after_validation :completa_campos_comprobante

  after_save :handle_approvement

  def at_least_one_order
    bills_orders.build if bills_orders.reject(&:marked_for_destruction?).size == 0
  end

  def merge_with_order
    product_details.each(&:merge_with_order) if saved_change_to_state? && confirmed?
  end

  def arrival_details
    Purchases::ArrivalDetail.where(
      arrival_id: file.arrivals.map(&:id)
    )
  end

  def self.search number
    return all if number.blank?
    where("#{table_name}.number ILIKE ?", "%#{number}%")
  end

  def handle_approvement
    generate_expense_supplier_account_movement if confirmation?
  end

  def cbte_fch
    read_attribute(:cbte_fch) || Date.today
  end

  def registration_date
    read_attribute(:registration_date) || Date.today
  end

  def due_date
    read_attribute(:due_date) || Date.today + 1.months
  end

  def has_pdf?
    false
  end

  def associate bill_id
    details.each(&:mark_for_destruction)
    bill = company.purchase_bills.find(bill_id)
    bill.details.each do |detail|
      details.build(detail.attributes.except(:id, :bill_id))
    end
  end

  private

  def confirmation?
    self.approved? && self.saved_change_to_state?
  end

  def generate_expense_supplier_account_movement
    SupplierManager::PurchaseBillConfirmator.call(self)
  end

  def completa_campos_comprobante
    self.sale_point  = self.sale_point.rjust(4, "0") unless self.sale_point.blank?
    self.number      = self.number.rjust(8, "0") unless self.number.blank?
  end
end
