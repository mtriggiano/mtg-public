class ExternalBill < GeneralBill
	self.table_name = :bills
	self.inheritance_column = :type
  attr_accessor :percep_iibb, :percep_iva
	include StateManager
	include HasDetails
	include Virtus.model(mass_assignment: false, constructor: false)
	include CustomAttributes
	include HasAttachments
	include Restricted
	include Reopener

	BILLS              = ["01", "06", "11", "201", "206", "211", "51"]
	DEBIT_NOTES        = ["02", "07", "12", "202", "207", "212", "52"]
	CREDIT_NOTES       = ["03", "08", "13", "203", "208", "213", "53"]
	CONFIRMED_STATES   = ["Confirmado", "Anulado parcialmente"]
	attribute :current_user, User
	belongs_to :entity
	belongs_to :user
	belongs_to :company
	belongs_to :parent, class_name: 'ExpedientBill', foreign_key: :parent_bill, optional: true
	belongs_to :payment_type, optional: true
	belongs_to :supplier, foreign_key: :entity_id

	has_many   :associated_documents, class_name: 'ExpedientBill', foreign_key: :parent_bill
	has_many   :credit_notes, ->{where(cbte_tipo: CREDIT_NOTES)}, class_name: name, foreign_key: :parent_bill
	has_many   :debit_notes, ->{where(cbte_tipo: DEBIT_NOTES)}, class_name: name, foreign_key: :parent_bill
	has_many   :receipt_bills, class_name: "ExpedientReceiptBill", foreign_key: :bill_id
	has_many   :receipts, class_name: "ExpedientReceipt", through: :receipt_bills
	has_many   :tributes, class_name: "ExpedientBillTribute", foreign_key: :bill_id, inverse_of: :bill
  has_many   :details,-> { order(created_at: :asc) }, class_name: "ExternalBillDetail", dependent: :destroy, foreign_key: "bill_id", inverse_of: :external_bill
	has_many 	 :payment_order_bills, class_name: "Purchases::PaymentOrderBill", foreign_key: :bill_id, inverse_of: :bill
	has_many 	 :payment_orders, through: :payment_order_bills
	has_many	 :account_movements, foreign_key: :bill_id

	inherit_details_from :expedient_order
	filter_details_from :external_arrival
	has_many :external_bills_expedient_orders, class_name: "ExternalBillOrder", foreign_key: :bill_id, inverse_of: :bill
	has_many :external_bills_external_arrivals, class_name: "ExternalBillArrival", foreign_key: :bill_id, inverse_of: :bill

	has_many :external_arrivals, through: :external_bills_external_arrivals
	has_many :external_arrival_details, through: :external_arrivals, source: :all_details
  has_many :expedient_orders, through: :external_bills_expedient_orders

	accepts_nested_attributes_for :external_bills_expedient_orders, reject_if: :all_blank, allow_destroy: true
	accepts_nested_attributes_for :external_bills_external_arrivals, reject_if: :all_blank, allow_destroy: true
	accepts_nested_attributes_for :details, reject_if: :all_blank, allow_destroy: true
	accepts_nested_attributes_for :tributes, reject_if: :all_blank, allow_destroy: true

	include BillValidator
	scope :confirmed, -> {where(state: CONFIRMED_STATES)}
	scope :unpaid, -> {where("bills.total > bills.total_pay")}
	scope :only_credit_notes, -> {where(cbte_tipo: CREDIT_NOTES)}
	scope :only_bills, -> {where(cbte_tipo: BILLS)}
	scope :not_credito_notes, -> {where.not(cbte_tipo: CREDIT_NOTES)}
	validates_associated :details
	before_validation :set_user,:set_total, :set_total_trib, :set_type
	after_save :check_shipment
	before_save :set_totals
	after_validation :completa_campos_comprobante
	after_save :destroy_movements_if_reopened

	after_save :handle_confirmation
	after_save :set_bill_due_notification

	default_scope ->{ where(flow: 'discharge')}

	CBTE_TIPO_COMPRAS = {"01"=>"Factura A",
	 "02"=>"Nota de Débito A",
	 "03"=>"Nota de Crédito A",
	 "06"=>"Factura B",
	 "07"=>"Nota de Debito B",
	 "08"=>"Nota de Credito B",
	 "11"=>"Factura C",
	 "12"=>"Nota de Debito C",
	 "13"=>"Nota de Credito C",
	 "51"=> "Factura M",
	 "52"=> "Nota de Débito M",
	 "53"=> "Nota de Crédito M",
	 "201"=>"Factura de Crédito electrónica MiPyMEs (FCE) A",
	 "202"=>"Nota de Débito electrónica MiPyMEs (FCE) A",
	 "203"=>"Nota de Crédito electrónica MiPyMEs (FCE) A",
	 "206"=>"Factura de Crédito electrónica MiPyMEs (FCE) B",
	 "207"=>"Nota de Débito electrónica MiPyMEs (FCE) B",
	 "208"=>"Nota de Crédito electrónica MiPyMEs (FCE) B",
	 "211"=>"Factura de Crédito electrónica MiPyMEs (FCE) C",
	 "212"=>"Nota de Débito electrónica MiPyMEs (FCE) C",
	 "213"=>"Nota de Crédito electrónica MiPyMEs (FCE) C"}


  def self.search(number)
    if !number.blank?
      	where("#{table_name}.number ILIKE ?", "%#{number}%")
    else
      	all
    end
  end

	def to_s
		"F.C. Nº #{number}"
	end

  def date
    cbte_fch.to_date
  end

	def registration_date
		super || Date.today
	end

  def set_type
  	self.type = "ExternalBill"
  end

  def handle_confirmation
  	confirmation_account_movement if approvement?
  	cancelation_account_movement if cancelation?
  end

  def confirmation_account_movement
  	SupplierManager::PurchaseBillConfirmator.call(self)
  end

  def cancelation_account_movement
  	SupplierManager::PurchaseBillAnulator.call(self)
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

	def approvement?
  	self.approved? && self.saved_change_to_state?
  end

	def cancelation?
  	self.canceled? && self.saved_change_to_state?
  end

  def completa_campos_comprobante
  	self.sale_point  = self.sale_point.rjust(4, "0") unless self.sale_point.blank?
  	self.number      = self.number.rjust(8, "0") unless self.number.blank?
  end

  def has_pdf?
  	false
  end

  def file
  	nil
  end

  def set_user
  	self.user_id ||= current_user.id
  end

  def recently_confirmed?
  	(state_changed? || saved_change_to_state?) && confirmed?
  end

  def flow_type
    flow == "income" ? "Compra" : "Venta"
  end

  def set_totals
    self.total_left = self.total unless self.total_pay > 0
  end

  # def reopened?
  #   #false
  # end

  def authorized_invoice?
    !self.cae.blank? && self.company.environment == "production"
  end

  def code_hash
    {
      cuit:       self.company.cuit,
      cbte_tipo:  self.cbte_tipo.to_s.rjust(3,padstr= '0'),
      pto_venta:  self.sale_point,
      cae:        self.cae,
      vto_cae:    self.cae_due_date
    }
  end

  def code_numbers(code_hash)
    require "check_digit.rb"
    code        = code_hash.values.join("")
    last_digit  = CheckDigit.new(code).calculate
    result      = "#{code}#{last_digit}"
    result.size.odd? ? "0" + result : result
  end

  def check_shipment
    bill_products = product_array
    shipment_products = eval("#{self.class.filter_details_from}_details").map{|d| {
      product: d.product_id,
      quantity: d.quantity
    }}
    if bill_products != shipment_products && eval("#{self.class.filter_details_from}_details").any?
      Notification::ExpedientBill.new(self).send_unmerged_stock
    end
  end

  def product_array
    details.map{|d| {
      product: d.product_id,
      quantity: d.quantity
    }}
  end

  def set_childs_parent
    #NO BORRAR
  end

  def comp_number
    self.number
  end

  def full_number
    if !editable?
      "#{sale_point}-#{comp_number}"
    else
      "Falta confirmar"
    end
  end

  def full_name
    "#{cbte_short_name}-#{full_number}"
  end

  def bills
    persisted? ? [self] : []
  end

  def real_total
    (total - associated_documents.only_credit_notes.sum(:total)).round(2)
  end

  def real_total_left
    (real_total - total_pay).round(2)
  end

  def disabled?
    not editable?
  end

  def tipo
    Afip::CBTE_TIPO[cbte_tipo]
  end

  def cbte_name
    case cbte_tipo
    when "01", "06", "11"
      "Factura"
    when "02", "07", "12"
      "Nota de Débito"
    when "03", "08", "13"
      "Nota de Crédito"
    end
  end

  def cbte_short_name
    case cbte_tipo
    when "01"
      "FA"
    when "06"
      "FB"
    when "11"
      "FC"
    when "02"
      "NDA"
    when "07"
      "NDB"
    when "12"
      "NDC"
    when "03"
      "NCA"
    when "08"
      "NCB"
    when "13"
      "NCC"
    end
  end

  def all_payments_string
    if self.receipts.any?
      array = []
      self.receipts.each do |receipt|
        receipt.payments.each do |payment|
          array << payment.payment_type.try(:name)
        end
      end
      return array.uniq.compact.join(', ')
    else
      return "Cta. Cte."
    end
  end

  def is_finished?
    state == "Confirmado"
  end

  def is_canceled?
    state == "Anulado"
  end

  def is?(document)
    eval(document.to_s.pluralize.upcase).include?(cbte_tipo)
  end

  def total_left_for_reports
    if self.is?(:credit_note)
      return (-total_left)
    else
      return (total_left)
    end
  end

  def name(format = :long)
    if format == :short
      full_name
    else
      "#{Afip::CBTE_TIPO[cbte_tipo]}-#{sale_point}-#{comp_number}"
    end
  end

  def set_client_activity
    activity = Activity.new(activitable_type: "#{entity.class.name}", activitable_id: entity_id, user: current_user, company_id: company_id)
    ActivityRecord.new(activity: activity, parent: {link: "/sale_bills/#{id}/edit", number: cae, tipo: tipo}).for_new_bill(state)
  end

  def iva_27
    iva_27 = 0
    self.details.where(iva_aliquot: "06").each do |detail|
      iva_27 += detail.iva_amount
    end
    return iva_27
  end

  def iva_21
    iva_21 = 0
    self.details.where(iva_aliquot: "05").each do |detail|
      iva_21 += detail.iva_amount
    end
    return iva_21
  end

  def iva_10
    iva_10 = 0
    self.details.where(iva_aliquot: "04").each do |detail|
      iva_10 += detail.iva_amount
    end
    return iva_10
  end

  def update_resume
    SaleResume.create_from_bill(self, self.created_at) if (is_finished? && saved_change_to_state?)
  end

  def set_total
    counter = 0
    details.each{ |detail| counter += detail.total }
    tributes.each{ |detail| counter += detail.amount }
    self.total = counter.round(2)
  end

  def set_total_trib
    self.total_trib = tributes.inject(0){|sum,tribute| sum += tribute.amount}
  end

  def build_from_sale_order sale_order_id
    build_from_order(company.sale_orders.find(sale_order_id))
  end

  def build_from_order order
    details.each{ |d| d.mark_for_destruction }
    order.details.whitout_childs.each do |detail|
      details.build(
        product_id:             detail.product_id,
        product_name:           detail.product_name,
        product_code:           detail.product_code,
        product_measurement:    detail.product_measurement,
        price:                  detail.price,
        discount:               detail.discount,
        quantity:               detail.quantity,
        bonus_amount:           detail.discount,
        iva_aliquot:            detail.iva_aliquot,
        total:                  detail.total.round(2)
      )
    end
    self.entity_id = order.entity_id
  end

  def cbte_types
    if entity
      BillManager::AfipBill.new(self).cbte_types
    else
      []
    end
  end

  def pdf_name
    full_name
  end

	def pay_total!
	  self.update_columns(total_pay: self.total, total_left: 0)
	end

  def rollback_pay_total!
    self.update_columns(total_left: self.total, total_pay: 0)
  end

	def cancelation_date
			if total_left == 0
				payment_orders.where(state: "Aprobado").order(updated_at: :desc).last.try(:date)
			end
	end

	def destroy_movements_if_reopened
	  if reopened? && saved_change_to_state? && state == "Pendiente"
			SupplierManager::PurchaseBillAnulator.new(self).actualiza_balance
			account_movements.update_all(active: false)
		end
	end
end
