class Surgeries::SupplierBill < ExpedientBill
  belongs_to :file, class_name: "Surgeries::File"
  belongs_to :supplier, foreign_key: :entity_id

  inherit_details_from :purchase_order
  filter_details_from :arrival
  has_many :supplier_bills_purchase_orders, class_name: "Surgeries::SupplierBillPurchaseOrder", foreign_key: :bill_id, inverse_of: :supplier_bill
  has_many :purchase_orders, through: :supplier_bills_purchase_orders
  has_many :supplier_bills_arrivals, class_name: "Surgeries::SupplierBillArrival", foreign_key: :bill_id, inverse_of: :supplier_bill
  has_many :arrivals, through: :supplier_bills_arrivals
  accepts_nested_attributes_for :supplier_bills_purchase_orders, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :supplier_bills_arrivals, reject_if: :all_blank, allow_destroy: true

  before_validation :at_least_one_purchase_order
  validates_presence_of :sale_point, message: "Debe especificar el punto de venta"
  validates_presence_of :supplier_bills_purchase_orders, message: 'Debe asignar al menos una orden de compra'

  after_validation :completa_campos_comprobante

  after_save :handle_approvement
  after_save :set_bill_due_notification

  default_scope ->{ where(flow: 'discharge')}

  def at_least_one_purchase_order
    supplier_bills_purchase_orders.build if supplier_bills_purchase_orders.size == 0
  end

  def handle_approvement
    generate_expense_supplier_account_movement if confirmation?
  end

  def set_bill_due_notification
    unless due_date.nil?
      five_days_not_date = due_date - 5.days
      ten_days_not_date = due_date - 10.days
      if ten_days_not_date.to_date >= Date.today
        BillManager::DueNotificator.new(self, 10).delay(run_at: ten_days_not_date.to_datetime).call if approvement?
      end
      if five_days_not_date.to_date >= Date.today
        BillManager::DueNotificator.new(self, 5).delay(run_at: five_days_not_date.to_datetime).call if approvement?
      end
      if due_date.to_date >= Date.today
				date_calc = due_date.to_date - Date.today
        BillManager::DueNotificator.new(self, date_calc.to_i).call if approvement?
      end
    end
  end

  def has_pdf?
    false
  end

  def arrival_details
    Surgeries::ArrivalDetail.where(
      arrival_id: file.arrivals.map(&:id)
    )
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
