class Purchases::PaymentOrder < ApplicationRecord
  self.table_name = "payment_orders"
  include Virtus.model(mass_assignment: false, constructor: false)
  include Restricted
  include Reopener
  include Numerable
  include StateManager
  include PaymentOrderValidator

  belongs_to :company
  belongs_to :supplier, foreign_key: :entity_id
  belongs_to :user

  has_many  :taxes, as: :taxable, dependent: :destroy
  has_many  :details, class_name: "Purchases::PaymentOrderBill", foreign_key: :payment_order_id, inverse_of: :payment_order, dependent: :destroy
  has_many  :payments, class_name: "Purchases::PaymentOrderPayment", foreign_key: :payment_order_id, inverse_of: :payment_order, dependent: :destroy
  has_many  :payment_expenses, as: :spendable, dependent: :destroy, foreign_key: :spendable_id
  has_many  :emitted_checks, dependent: :destroy

  has_many :payment_types, through: :payments

  attribute :current_user, User

  accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :taxes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :payments, reject_if: :all_blank, allow_destroy: true

  scope :approveds, ->{where(state: ["Aprobado", "Confirmado"])}

  validate :payment_matcher
  after_save :handle_confirmated_payments, :handle_cancelled_payments

  def self.in_month date=nil
    from =  date && date.to_date.beginning_of_month || Date.today.beginning_of_month
    to = from + 1.month
    approveds.where(date: from..to)
  end

  def responsables
    [company.departments.find_by_name("Proveedores").try(:user)]
  end

  def bill_id
    read_attribute(:bill_id)
  end

  def name
    "OP-#{number}"
  end

  def total_pay
    payments.sum(:total).to_f + taxes.sum(:total).to_f
  end

  def handle_confirmated_payments
    if self.approved? &&  self.saved_change_to_state?
      PaymentsManager::PaymentOrderConfirmator.call(self)
      SupplierManager::PaymentOrderConfirmator.call(self)
    end
  end

  def handle_cancelled_payments
    if self.canceled? &&  self.saved_change_to_state?
      PaymentsManager::PaymentOrderCancelator.call(self)
      SupplierManager::PaymentOrderCancelator.call(self)
    end
  end

  def has_pdf?
    true
  end

  def pdf_name
    "orden_pago_#{number}"
  end

  def start_time
    date
  end

  private

  def payment_matcher
    facturas_imp  = self.details.reject(&:marked_for_destruction?).pluck(:total).inject(0, :+)
    retenciones   = self.taxes.reject(&:marked_for_destruction?).pluck(:total).inject(0, :+)
    pagos         = self.payments.reject(&:marked_for_destruction?).pluck(:total).inject(0, :+) + retenciones.to_f.round(2)
    unless facturas_imp.to_f.round(2) == pagos.to_f.round(2)
      errors.add(:base, "La suma de pagos no coinicide con los comprobantes a pagar. A pagar: #{facturas_imp.to_f.round(2)}. Pagos: #{pagos.to_f.round(2)}")
    end
  end

  def need_rollback?
    previous_changes[:state] == ["Finalizado", "Pendiente"] ||
    previous_changes[:state] == ["Finalizado", "Anulado"]   ||
    previous_changes[:state] == ["Confirmado", "Pendiente"] ||
    previous_changes[:state] == ["Confirmado", "Anulado"]   ||
    previous_changes[:state] == ["Aprobado", "Pendiente"]   ||
    previous_changes[:state] == ["Aprobado", "Anulado"]
  end
end
