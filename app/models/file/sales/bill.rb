class Sales::Bill < ExpedientBill
  include Notificable
  include Reopener
  belongs_to :file, class_name: "Sales::File", foreign_key: :file_id
  belongs_to :client, foreign_key: :entity_id

  has_many :bills_orders, class_name: "Sales::BillOrder", foreign_key: :bill_id, inverse_of: :bill
  has_many :orders, through: :bills_orders
  has_many :bills_shipments, class_name: "Sales::BillShipment", foreign_key: :bill_id, inverse_of: :bill
  has_many :shipments, through: :bills_shipments
  has_many :shipment_details, through: :shipments, source: :details
  has_many :product_details, class_name: "Sales::BillInventary", foreign_key: :bill_id, inverse_of: :bill
  has_many :service_details, class_name: "Sales::BillService", foreign_key: :bill_id, inverse_of: :bill
  has_many :receipts_bills, class_name: "ExpedientReceiptBill"
  validates_presence_of :fch_vto_pago, message: "Debe especificar"

  inherit_details_from :order
  filter_details_from :shipment

  accepts_nested_attributes_for :bills_orders, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :bills_shipments, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :product_details, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :service_details, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :file, allow_destroy: true, reject_if: :all_blank

  after_validation :confirm

  after_save :set_account_movement
  after_save :create_shipment
  before_validation :set_due_date
  default_scope ->{where(flow: "income")}

  before_validation :at_least_one_order

  def at_least_one_order
    bills_orders.build if bills_orders.reject(&:marked_for_destruction?).size == 0
  end

  def department
    "Ventas"
  end

  def confirm
    BillManager::Confirmator.confirm(self) unless errors.any?
  end

  def set_account_movement
    ClientManager::SaleBillConfirmator.call(self) if recently_confirmed?
  end

  def create_shipment
    # if file.sale_type == "Venta por mostrador" && saved_change_to_state? && confirmed?
    #   SaleManager::ShipmentGenerator.new(self).call
    # end
  end

  def cbte_fch
    read_attribute(:cbte_fch) || Date.today
  end

  def cbte_tipo
    read_attribute(:cbte_tipo)
  end

  def has_credit_note?
    credit_notes.any?
  end

  def has_debit_note?
    debit_notes.any?
  end

  def associate bill_id
    details.each(&:mark_for_destruction)
    bill = company.sale_bills.find(bill_id)
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
