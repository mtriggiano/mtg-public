class Surgeries::ClientBill < ExpedientBill
  include Notificable
  belongs_to :file, class_name: "Surgeries::File", foreign_key: :file_id, inverse_of: :client_bills
  belongs_to :client, foreign_key: :entity_id
  has_many :client_bills_sale_orders, class_name: "Surgeries::ClientBillSaleOrder", foreign_key: :bill_id, inverse_of: :bill
  has_many :sale_orders, through: :client_bills_sale_orders, source: :sale_order
  has_many :client_bills_shipments, class_name: "Surgeries::ClientBillShipment", foreign_key: :bill_id, inverse_of: :bill
  has_many :shipments, through: :client_bills_shipments
  has_many :shipment_details, through: :shipments, source: :details
  inherit_details_from :sale_order
  filter_details_from :shipment

  accepts_nested_attributes_for :client_bills_sale_orders, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :client_bills_shipments, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :file, allow_destroy: false

  has_many :product_details, class_name: "Surgeries::ClientBillInventary", foreign_key: :bill_id, inverse_of: :client_bill
  has_many :service_details, class_name: "Surgeries::ClientBillService", foreign_key: :bill_id, inverse_of: :client_bill

  accepts_nested_attributes_for :product_details, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :service_details, allow_destroy: true, reject_if: :all_blank

  after_validation :confirm
  after_save :set_account_movement
  before_validation :set_sale_point, :at_least_one_sale_order, :set_due_date
  validates_presence_of :fch_ser_desde, if: :not_only_products, message: "Debe ingresar"
  validates_presence_of :fech_ser_hasta, if: :not_only_products, message: "Debe ingresar"

  default_scope ->{where(flow: "income")}

  def department
    "Ventas"
  end

  def to_s
		"F.V. Nº #{number}"
  end

  def at_least_one_sale_order
    client_bills_sale_orders.build if client_bills_sale_orders.size == 0
  end

  def set_sale_point
    self.sale_point ||= company.sale_points.last.try(:number)
  end

  def set_account_movement
    ClientManager::SaleBillConfirmator.call(self) if recently_confirmed?
  end

  def not_only_products
    details.select{|d| d.is_a_service?}.compact.any?
  end

  def confirm
    BillManager::Confirmator.confirm(self) unless errors.any?
  end

  def cbte_fch
    read_attribute(:cbte_fch) || Date.today
  end

  def concept
    read_attribute(:concept) || "Productos"
  end

  def has_credit_note?
    credit_notes.any?
  end

  def has_debit_note?
    debit_notes.any?
  end

  def associate bill_id
    details.each(&:mark_for_destruction)
    bill = company.surgery_client_bills.find(bill_id)
    bill.details.each do |detail|
      details.build(detail.attributes.except(:id, :bill_id))
    end
  end

  def has_pdf?
    manual == "E"
  end

  def set_due_date
    self.fch_vto_pago = self.cbte_fch.to_date + self.due_days.to_i.days
  end

end
