class ExpedientReceipt < ApplicationRecord
  self.table_name = :receipts
  include Virtus.model(mass_assignment: false, constructor: false)
  include CustomAttributes
  include HasAttachments
  #include HasDetails
  include Restricted
  include Numerable
  include Reopener
  include StateManager
  include ReceiptValidator

  attribute :current_user, User
  belongs_to :client, foreign_key: :entity_id
  belongs_to :user
  belongs_to :company

  has_many :receipt_details, class_name: "ExpedientReceiptBill", foreign_key: :receipt_id, inverse_of: :receipt
  has_many :payments, class_name: "ExpedientReceiptPayment", foreign_key: :receipt_id, inverse_of: :receipt
  has_many :bank_accounts, through: :payments
  has_many :payment_types, through: :payments
  has_many :taxes, as: :taxable
  has_many :bills, through: :receipt_details
  has_many :responsables, through: :bills
  has_many :payment_incomes, as: :spendable, dependent: :destroy, foreign_key: :spendable_id
  has_many :payment_expenses, as: :spendable, dependent: :destroy, foreign_key: :spendable_id
  has_many :bank_check_expenses, as: :spendable, dependent: :destroy, foreign_key: :spendable_id
  has_many :promissory_note_expenses, as: :spendable, dependent: :destroy, foreign_key: :spendable_id

  accepts_nested_attributes_for :receipt_details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :taxes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :payments, reject_if: :all_blank, allow_destroy: true

  after_save :handle_confirmation, :handle_anullment
  before_validation :set_user
  validates_associated :taxes
  validate :payment_matcher

  def handle_confirmation
    if confirmation?
      PaymentsManager::ReceiptConfirmator.call(self)
      ClientManager::ReceiptConfirmator.call(self)
    end
  end

  def has_account_payment?
    details.map{|d| d.bill_id.nil?}.include?(true)
  end

  def has_available_account_payment?
    details.sum(&:available_to_assign) > 0
  end

  def charge_receipt bill_id
    bill = ExpedientBill.find(bill_id)
    PaymentsManager::ReceiptConfirmator.call(self)
  end

  def handle_anullment
    if anullment?
      PaymentsManager::ReceiptCancelator.call(self)
      ClientManager::ReceiptCancelator.call(self)
    end
  end

  def self.payment_types company
    company.payment_types.order(:name).map{|pt| [pt.name.upcase, pt.id]}
  end

  def confirmation?
    self.approved? &&  self.saved_change_to_state?
  end

  def anullment?
    self.canceled? &&  self.saved_change_to_state?
  end

  def self.search(number)
    if !number.blank?
      where("#{table_name}.number ILIKE ?", "%#{number}%")
    else
      all
    end
  end

  def self.report_search(attr={})
    date_range = [attr[:from], attr[:to]].compact.delete_if{ |k,v| v.blank? }
    pp opts = {
      date: date_range.empty? ? nil : date_range,
      entity_id: attr[:clients],
      receipts_payments: {
        id: attr[:payment_types],
        bank_account_id: attr[:banks]
      }.compact
    }.compact.delete_if{ |k,v| v.blank? }
    joins(:payments).where(opts)
  end

  def set_user
    self.user_id = current_user.id
  end

  def name(format = :long)
    if canceled?
      tipo = "Recibo Anulado"
    else
      tipo = "Recibo"
    end
    return format == :long ?
      "#{tipo} Nº #{number}" :
      "X-#{number}"
  end

  def is_finished?
    state == "Aprobado"
  end

  def need_rollback?
    previous_changes[:state] == ["Finalizado", "Pendiente"] ||
    previous_changes[:state] == ["Finalizado", "Anulado"]   ||
    previous_changes[:state] == ["Confirmado", "Pendiente"] ||
    previous_changes[:state] == ["Confirmado", "Anulado"]   ||
    previous_changes[:state] == ["Aprobado", "Pendiente"]   ||
    previous_changes[:state] == ["Aprobado", "Anulado"]
  end

  def has_pdf?
    true
  end

  def pdf_name
    "recibo_#{number}"
  end

  def details
    receipt_details
  end

  private

  def payment_matcher
    facturas_imp  = self.details.reject(&:marked_for_destruction?).pluck(:total).inject(0, :+)
    percepciones  = self.taxes.reject(&:marked_for_destruction?).pluck(:total).inject(0, :+)
    pagos         = self.payments.reject(&:marked_for_destruction?).pluck(:total).inject(0, :+) + percepciones
    true
    #errors.add(:base, "El total de pagos no coinicide con los comprobantes a pagar.") if facturas_imp != pagos
  end


end
