class ExpedientBill < GeneralBill
  self.table_name = :bills
  self.inheritance_column = :type
  include StateManager
  include HasDetails
  include Virtus.model(mass_assignment: false, constructor: false)
  include CustomAttributes
  include HasAttachments
  include Restricted

  BILLS              = ["01", "06", "11", "201", "206", "211"]
  DEBIT_NOTES        = ["02", "07", "12", "202", "207", "212"]
  CREDIT_NOTES       = ['03', '08', '13', '203', '208', '213']
  CONFIRMED_STATES   = ["Confirmado", "Anulado parcialmente"]
  DUE_DAYS = [["60 Días", 60], ["45 Dias", 45], ["30 Días", 30], ["15 Días", 15], ["7 Días", 7]]

  belongs_to :expedient_file, class_name: "Expedient", foreign_key: :file_id
  alias_method :file, :expedient_file
  belongs_to :user
  belongs_to :entity, foreign_key: :entity_id
  belongs_to :company
  belongs_to :parent, class_name: 'ExpedientBill', foreign_key: :parent_bill, optional: true
  belongs_to :payment_type, optional: true

	has_many   :associated_documents, class_name: 'ExpedientBill', foreign_key: :parent_bill
  has_many   :credit_notes, ->{where(cbte_tipo: CREDIT_NOTES)}, class_name: name, foreign_key: :parent_bill
  has_many   :debit_notes, ->{where(cbte_tipo: DEBIT_NOTES)}, class_name: name, foreign_key: :parent_bill
  has_many   :requests, through: :expedient_file
  has_many   :budgets,  through: :expedient_file, source: :expedient_budgets
  has_many   :orders,   through: :expedient_file, source: :sale_orders
  has_many   :receipt_bills, class_name: "ExpedientReceiptBill", foreign_key: :bill_id
  has_many   :receipts, class_name: "ExpedientReceipt", through: :receipt_bills
  has_many   :shipments, through: :expedient_file
  has_many   :sale_resume_details, as: :detailable
  has_many   :responsables, through: :expedient_file
  has_many   :tributes, class_name: "ExpedientBillTribute", foreign_key: :bill_id, inverse_of: :bill
  has_many   :optionals, class_name: "BillOptional", inverse_of: :expedient_bill, foreign_key: :bill_id
  has_many   :sellers, through: :details
  after_save :check_shipment
  before_create :set_totals
  before_validation :set_date

  include BillValidator

  attribute :current_user, User
  accepts_nested_attributes_for :tributes, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :optionals, reject_if: :all_blank, allow_destroy: true

  scope :confirmed, -> {where(state: CONFIRMED_STATES)}
  scope :unpaid, -> {where("bills.total > bills.total_pay")}
  scope :only_credit_notes, -> {where(cbte_tipo: CREDIT_NOTES)}
  scope :only_debit_notes, -> {where(cbte_tipo: DEBIT_NOTES)}
  scope :only_bills, -> {where(cbte_tipo: BILLS)}
  scope :not_credito_notes, -> {where.not(cbte_tipo: CREDIT_NOTES)}

  before_validation :set_user,:set_total, :set_total_left, :set_total_trib
  validates_associated :details
  after_validation :cancel

  include ReportsKit::Model
  reports_kit do
    aggregation :total_selled, [:sum_and_filter, ""]
    dimension :date, group: 'EXTRACT( MONTH FROM bills.date)'
    filter :date, :datetime, column: 'bills.date'
    dimension :entity, joins: :entity, group: 'entities.name'
  end

  def self.search(number)
    if !number.blank?
      where("#{table_name}.number ILIKE ?", "%#{number}%")
    else
      all
    end
  end

  def self.search_by_id ids
    return all if ids.blank?
    where(id: ids)
  end

  def self.search_by_seller sellers
    return all if sellers.blank?
    joins(:sellers).where(users: {id: sellers})
  end

  def self.sub_search from: Date.today - 1.months, to: Date.today, sellers:
    return where("1=0") if sellers.nil? || sellers.size == 0
    joins(:details)
      .where(bill_details: {seller_id: sellers})
      .where(date: [from..to])
  end

  def self.sum_and_filter attr
    approveds.where(canceled: false).sum(:total)
  end

  def add_tributes aliquot=3.6
    tributes.build(afip_id: "7", base_imp: 0, alic: aliquot, amount: 0, description: "Percepción de IIBB")
  end

  def set_date
    if self.cbte_fch.respond_to?(:to_date)
      self.date = self.cbte_fch.to_date
    else
      self.date ||= self.updated_at.to_date
    end
  end

  def sale_point
    super || "00006"
  end

  def cancelation_date
    receipts.order(date: :desc).first.try(:date) if total_left <= 0
  end

  def recently_confirmed?
    (state_changed? || saved_change_to_state?) && confirmed?
  end

  def flow_type
    flow == "income" ? "Compra" : "Venta"
  end

  def set_totals
    self.total_left = self.total
  end

  def reopened?
    false
  end

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
    unless self.class.filter_details_from.blank?
      bill_products = product_array
      shipment_products = eval("#{self.class.filter_details_from}_details").map{|d| {
        product: d.product_id,
        quantity: d.quantity
      }}
      if bill_products != shipment_products && eval("#{self.class.filter_details_from}_details").any?
        Notification::ExpedientBill.new(self).send_unmerged_stock
      end
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

  def set_user
    self.user_id ||= current_user.id
  end

  def comp_number
    self.number
  end

  def full_number
    if !editable?
      "#{sale_point.rjust(5,padstr= '0')}-#{comp_number}"
    else
      "Falta confirmar"
    end
  end

  def full_name
    "#{cbte_short_name}-#{full_number}"
  end

  # def sellers
  #   result = []
  #   orders.each do |order|
  #     order.details.each do |detail|
  #       result << detail.user.try(:name)
  #     end
  #   end
  #   return result.compact.uniq.join(", ")
  # end

  def cancel
    if is_canceled? && state_changed? && !["Purchases::Bill", "Surgeries::SupplierBill"].include?(self.class.name)
      errors.add(:base, "No se pudo anular") unless BillManager::AfipCreditNote.make_credit_note(self)
    end
  end

  def bills
    persisted? ? [self] : []
  end

  def real_total
    (total - associated_documents.only_credit_notes.sum(:total) + associated_documents.only_debit_notes.sum(:total)).round(2)
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
    when "01", "06", "11", "51"
      "Factura"
    when "02", "07", "12", "52"
      "Nota de Débito"
    when "03", "08", "13", "53"
      "Nota de Crédito"
    when "201", "206", "211"
      "Factura de Crédito Elec."
    when "202", "207", "212"
      "Nota de Débito Elec."
    when "203", "208", "213"
      "Nota de Crédito Elec."
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
    when "201"
      "FCE A"
    when "202"
      "NDE A"
    when "203"
      "NCE A"
    when "206"
      "FCE B"
    when "207"
      "NDE B"
    when "208"
      "NCE B"
    when "211"
      "FCE C"
    when "212"
      "NDE C"
    when "213"
      "NCE C"
    when "51"
      "FM"
    when "52"
      "NDM"
    when "53"
      "NCM"
    end
  end

  def cbte_long_name
    case cbte_tipo
    when "01"
      "Factura A"
    when "06"
      "Factura B"
    when "11"
      "Factura C"
    when "02"
      "Nota de Débito A"
    when "07"
      "Nota de Débito B"
    when "12"
      "Nota de Débito C"
    when "03"
      "Nota de Crédito A"
    when "08"
      "Nota de Crédito B"
    when "13"
      "Nota de Crédito C"
    when "201"
      "Factura de Crédito Elec. A"
    when "202"
      "Nota de Débito Elec. A"
    when "203"
      "Nota de Crédito Elec. A"
    when "206"
      "Factura de Crédito Elec. B"
    when "207"
      "Nota de Débito Elec. B"
    when "208"
      "Nota de Crédito Elec. B"
    when "211"
      "Factura de Crédito Elec. C"
    when "212"
      "Nota de Débito Elec. C"
    when "213"
      "Nota de Crédito Elec. C"
    when "51"
      "Factura M"
    when "52"
      "Nota de Débito M"
    when "53"
      "Nota de Crédito M"
    end
  end

  def self.update_dates
    where(state: ["Anulado", "Confirmado"], type: ["Sales::Bill", "Surgeries::ClientBill", "Tenders::Bill"]).each do |bill|
      if !bill.authorized_on.blank?
        bill.update_column(:date, Date.strptime(bill.authorized_on, "%Y%m%d%H%M%S"))
      elsif !bill.cbte_fch.blank?
        bill.update_column(:date, bill.cbte_fch.to_date)
      end
    end
  end

  def self.cbte_short_name_inverse(t)
    case t.upcase
    when "FA"
      "01"
    when "FB"
      "06"
    when "FC"
      "11"
    when "NDA"
      "02"
    when "NDB"
      "07"
    when "NDC"
      "12"
    when "NCA"
      "03"
    when "NCB"
      "08"
    when "NCC"
      "13"
    when "FCE A"
      "201"
    when "NDE A"
      "202"
    when "NCE A"
      "203"
    when "FCE B"
      "206"
    when "NDE B"
      "207"
    when "NCE B"
      "208"
    when "FCE C"
      "211"
    when "NDE C"
      "212"
    when "NCE C"
      "213"
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

  def need_merge?
    true
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
    details.reject(&:marked_for_destruction?).each{ |detail| counter += detail.total }
    tributes.reject(&:marked_for_destruction?).each{ |detail| counter += detail.amount }
    self.total = counter.round(2)
  end

  def set_total_left
    if type == "Sales::Bill" || type == "Surgeries::ClientBill" || type == "Tenders::Bill"
      counter = 0
      receipt_bills.each{ |receipt_detail| counter += receipt_detail.total }
      self.total_left = (self.total - counter).round(2)
      self.total_pay  = counter.round(2)
    end
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


  def merge_operation
    if is?(:credit_note)
      return "-"
    end
  end

  def qr_for_pdf
    require 'json'
    json = {
        "ver" => "1".to_i,
        "fecha" => I18n.l(self.cbte_fch.to_datetime, format: :full_afip_date).to_s,
        "cuit" => self.company.cuit.to_i,
        "ptoVta" => self.sale_point.to_i,
        "tipoCmp" => self.cbte_tipo.to_i,
        "nroCmp" => self.number.to_i,
        "importe" => self.total.round(2),
        "moneda" => self.currency == "ARS" ? "PES" : "DOL",
        "ctz" => self.currency == "ARS" ? 1 : self.usd_price.to_f.round(2),
        "tipoCodAut" => "E",
        "codAut" => self.cae.to_i
    }

    #pp json = "{'ver':1,'fecha':'#{I18n.l(self.cbte_fch.to_datetime, format: :full_afip_date).to_s}','cuit':#{self.company.cuit.to_i},'ptoVta':#{self.sale_point.to_i},'tipoCmp':#{self.cbte_tipo.to_i},'nroCmp':#{self.number.to_i},'importe':#{self.total.round(2)},'moneda':#{self.currency == "ARS" ? "PES" : "DOL"},'ctz':#{self.currency == "ARS" ? 1 : self.usd_price.to_f.round(2)},'tipoCodAut':'E','codAut':#{self.cae.to_i}}"
    base64 = Base64.encode64(json.to_json)
    url = "https://www.afip.gob.ar/fe/qr/?p=#{base64}".tr("\n","")
    qr = RQRCode::QRCode.new(url).to_img.resize(200, 200).to_data_url
    return qr
  end

end
