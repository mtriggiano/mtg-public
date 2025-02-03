class Tenders::Bill < ExpedientBill
  include Notificable
  belongs_to :file, class_name: "Tenders::File", foreign_key: :file_id
  belongs_to :client, foreign_key: :entity_id
  has_many :bills_orders, class_name: "Tenders::BillOrder", foreign_key: :bill_id, inverse_of: :bill
  has_many :orders, through: :bills_orders
  has_many :bills_shipments, class_name: "Tenders::BillShipment", foreign_key: :bill_id, inverse_of: :bill
  has_many :shipments, through: :bills_shipments
  has_many :shipment_details, through: :shipments, source: :details
  inherit_details_from :order
  filter_details_from :shipment
  accepts_nested_attributes_for :bills_orders, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :bills_shipments, allow_destroy: true, reject_if: :all_blank
  has_many :product_details, class_name: "Tenders::BillInventary", foreign_key: :bill_id, inverse_of: :bill
  has_many :service_details, class_name: "Tenders::BillService", foreign_key: :bill_id, inverse_of: :bill

  accepts_nested_attributes_for :product_details, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :service_details, allow_destroy: true, reject_if: :all_blank
  after_validation :confirm
  after_save :merge_with_order, :set_account_movement

  #validates_presence_of :bills_orders, message: "Debe asociar al menos una orden"

  default_scope ->{where(flow: "income")}

  before_validation :at_least_one_order, :set_due_date


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

  def cbte_fch
    read_attribute(:cbte_fch) || Date.today
  end

  def merge_with_order
    product_details.each{|detail| detail.merge_with_order }
  end

  def has_credit_note?
    credit_notes.any?
  end

  def has_debit_note?
    debit_notes.any?
  end

  def associate bill_id
    details.each(&:mark_for_destruction)
    bill = company.surgery_bills.find(bill_id)
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
