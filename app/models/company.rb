class Company < ApplicationRecord
  belongs_to :locality                , optional: true
  has_one    :general_cash_account    , dependent: :destroy
  has_many   :expenditures            , dependent: :destroy
  has_many   :regular_cash_accounts   , dependent: :destroy
  has_many   :cash_accounts           , dependent: :destroy
  has_many   :promissory_payments     , dependent: :destroy
  has_many   :bank_check_payments     , dependent: :destroy
  has_many   :promissory_note_payments, dependent: :destroy
  has_many 	 :users                   , dependent: :destroy
  has_many 	 :sale_points             , dependent: :destroy
  has_many 	 :banks                   , dependent: :destroy
  has_many 	 :bank_accounts           , through:   :banks
  has_many   :checkbooks              , through:   :bank_accounts
  has_many   :emitted_checks          , dependent: :destroy
  has_many   :general_cash_expenses   , dependent: :destroy
  has_many   :incomes                 , dependent: :destroy
  has_many   :cash_solicitudes        , dependent: :destroy
  has_many   :imprest_systems         , dependent: :destroy
  has_many   :cards                   , dependent: :destroy
  has_many   :suppliers               , dependent: :destroy
  has_many   :product_categories      , dependent: :destroy
  has_many   :inventaries             , through:   :product_categories, dependent: :destroy
  has_many   :products                , through:   :product_categories, dependent: :destroy
  has_many   :batches                 , through:   :products, dependent: :destroy
  has_many   :boxes                   , through:   :product_categories, dependent: :destroy
  has_many   :stocks                  , through:   :products, dependent: :destroy
  has_many   :stores                  , dependent: :destroy
  has_many   :local_stores            , dependent: :destroy
  has_many   :external_stores         , dependent: :destroy
  has_many   :store_lines             , through:   :external_stores, source: :lines
  has_many   :clients                 , dependent: :destroy
  has_many   :stock_requests          , dependent: :destroy
  has_many   :alerts                  , dependent: :destroy
  has_many   :departments             , dependent: :destroy
  has_many   :transfer_notes          , dependent: :destroy
  has_many   :payment_types           , dependent: :destroy
  has_many   :expedients              , dependent: :destroy
  has_many   :roles                   , dependent: :destroy
  has_many   :supplier_products       , dependent: :destroy, through: :products
  has_many   :batches                 , dependent: :destroy, through: :products
  has_many   :expedient_requests      , dependent: :destroy
  has_many   :expedient_shipments     , ->{where(type: ["Sales::Shipment", "Surgeries::Shipment", "Tenders::Shipment"])}, dependent: :destroy
  has_many   :expedient_shipment_details       , dependent: :destroy, through: :expedient_shipments, source: :all_details
  has_many   :expedient_receipts      , dependent: :destroy
  has_many   :expedient_consumptions  , dependent: :destroy
  has_many   :expedient_orders        , dependent: :destroy
  has_many   :expedient_arrivals      , dependent: :destroy
  has_many   :expedient_bills         , ->{where(type: ["Sales::Bill", "Surgeries::ClientBill", "Tenders::Bill"])}, dependent: :destroy
  has_many   :expedient_bill_details  , through: :expedient_bills, source: :details
  has_many   :taxes                   , dependent: :destroy
  has_many   :external_bills          , dependent: :destroy
  has_many   :external_arrivals       , dependent: :destroy
  has_many   :external_shipments      , dependent: :destroy
  has_many   :tickets                 , dependent: :destroy
  #PURCHASES
  has_many   :purchase_file_movements     , dependent: :destroy, through: :purchase_files, source: :file_movements
  has_many   :purchase_files              , dependent: :destroy, class_name: 'Purchases::File'
  has_many   :purchase_purchase_requests  , dependent: :destroy, class_name: 'Purchases::PurchaseRequest'
  has_many   :purchase_orders             , dependent: :destroy, class_name: 'Purchases::Order'
  has_many   :purchase_budgets            , dependent: :destroy, class_name: 'Purchases::Budget'
  has_many   :purchase_arrivals           , dependent: :destroy, class_name: 'Purchases::Arrival'
  has_many   :purchase_bills              , dependent: :destroy, class_name: "Purchases::Bill"
  has_many   :purchase_devolutions        , dependent: :destroy, class_name: "Purchases::Devolution"
  has_many   :purchase_payment_orders     , dependent: :destroy, class_name: "Purchases::PaymentOrder"
  #SALES
  has_many   :sale_files              , dependent: :destroy, class_name: "Sales::File"
  has_many   :sale_sale_requests      , dependent: :destroy, class_name: "Sales::SaleRequest"
  has_many   :sale_budgets            , dependent: :destroy, class_name: "Sales::Budget"
  has_many   :sale_orders             , dependent: :destroy, class_name: "Sales::Order"
  has_many   :sale_bills              , dependent: :destroy, class_name: "Sales::Bill"
  has_many   :sale_bill_details              , dependent: :destroy, class_name: "Sales::BillDetail", through: :expedient_bills, source: :details
  has_many   :sale_shipments          , dependent: :destroy, class_name: "Sales::Shipment"
  has_many   :sale_receipts           , dependent: :destroy, class_name: "Sales::Receipt"
  #TENDERS
  has_many   :tender_files              , dependent: :destroy, class_name: "Tenders::File"
  has_many   :tender_supplier_budgets   , dependent: :destroy, class_name: "Tenders::SupplierBudget"
  has_many   :tender_budgets            , dependent: :destroy, class_name: "Tenders::Budget"
  has_many   :tender_orders             , dependent: :destroy, class_name: "Tenders::Order"
  has_many   :tender_bills              , dependent: :destroy, class_name: "Tenders::Bill"
  has_many   :tender_shipments          , dependent: :destroy, class_name: "Tenders::Shipment"
  has_many   :tender_sale_requests      , dependent: :destroy, class_name: "Tenders::SaleRequest"
  #SURGERIES
  has_many   :file_attributes_config    , dependent: :destroy
  has_many   :surgery_files             , dependent: :destroy, class_name: "Surgeries::File"
  has_many   :surgery_consumptions      , dependent: :destroy, class_name: "Surgeries::Consumption"
  has_many   :surgery_devolutions       , dependent: :destroy, class_name: "Surgeries::Devolution"
  has_many   :surgery_prescriptions     , dependent: :destroy, class_name: "Surgeries::Prescription"
  has_many   :surgery_purchase_requests , dependent: :destroy, class_name: "Surgeries::PurchaseRequest"
  has_many   :surgery_supplier_requests , dependent: :destroy, class_name: "Surgeries::SupplierRequest"
  has_many   :surgery_budgets           , dependent: :destroy, class_name: "Surgeries::Budget"
  has_many   :surgery_purchase_orders   , dependent: :destroy, class_name: "Surgeries::PurchaseOrder"
  has_many   :surgery_sale_orders       , dependent: :destroy, class_name: "Surgeries::SaleOrder"
  has_many   :surgery_shipments         , dependent: :destroy, class_name: "Surgeries::Shipment"
  has_many   :surgery_arrivals          , dependent: :destroy, class_name: "Surgeries::Arrival"
  has_many   :surgery_client_bills      , dependent: :destroy, class_name: "Surgeries::ClientBill"
  has_many   :surgery_supplier_bills    , dependent: :destroy, class_name: "Surgeries::SupplierBill"
  has_many   :surgery_receipts          , dependent: :destroy, class_name: "Surgeries::Receipt"

  has_many   :surgery_requests             , dependent: :destroy, class_name: "AgreementSurgeries::SurgeryRequest"
  has_many   :surgery_materials            , dependent: :destroy, class_name: "AgreementSurgeries::SurgeryMaterial"
  has_many   :price_updates                , dependent: :destroy, class_name: "AgreementSurgeries::PriceUpdate"
  has_many   :agreement_surgery_files      , dependent: :destroy, class_name: "AgreementSurgeries::File"
  has_many   :agreement_surgery_sale_orders, dependent: :destroy, class_name: "AgreementSurgeries::SaleOrder"
  has_many   :agreement_surgery_shipments  , dependent: :destroy, class_name: "AgreementSurgeries::Shipment"


  has_many   :insurances                , dependent: :destroy
  has_many   :activities

  has_many   :expedient_receipt_configs,             ->{where(parent_model: "ExpedientReceipt")},      dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_consumption_configs,      ->{where(parent_model: "Surgeries::Consumption")},      dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_devolution_configs,       ->{where(parent_model: "Surgeries::Devolution")},       dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_budget_configs,           ->{where(parent_model: "Surgeries::Budget")},           dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_sale_order_configs,       ->{where(parent_model: "Surgeries::SaleOrder")},        dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :agreement_surgery_sale_order_configs, ->{where(parent_model: "AgreementSurgeries::SaleOrder")}, dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :agreement_surgery_shipment_configs, ->{where(parent_model: "AgreementSurgeries::Shipment")}, dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_purchase_request_configs, ->{where(parent_model: "Surgeries::Request")},          dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_supplier_request_configs, ->{where(parent_model: "Surgeries::SupplierRequest")},  dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_prescription_configs,     ->{where(parent_model: "Surgeries::Prescription")},     dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_arrival_configs,          ->{where(parent_model: "Surgeries::Arrival")},          dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_shipment_configs,         ->{where(parent_model: "Surgeries::Shipment")},         dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_purchase_order_configs,   ->{where(parent_model: "Surgeries::PurchaseOrder")},    dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_client_bill_configs,      ->{where(parent_model: "Surgeries::ClientBill")},       dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_supplier_bill_configs,    ->{where(parent_model: "Surgeries::SupplierBill")},     dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :surgery_receipt_configs,          ->{where(parent_model: "Surgeries::Receipt")},     dependent: :destroy, class_name: "FileAttributesConfig"

  has_many   :sale_sale_request_configs,        ->{where(parent_model: "Sales::SaleRequest")},         dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :sale_budget_configs,              ->{where(parent_model: "Sales::Budget")},              dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :sale_order_configs,               ->{where(parent_model: "Sales::Order")},               dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :sale_bill_configs,                ->{where(parent_model: "Sales::Bill")},                dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :sale_shipment_configs,            ->{where(parent_model: "Sales::Shipment")},            dependent: :destroy, class_name: "FileAttributesConfig"

  has_many   :tender_supplier_budget_configs,            ->{where(parent_model: "Tenders::SupplierBudget")},              dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :tender_budget_configs,            ->{where(parent_model: "Tenders::Budget")},              dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :tender_order_configs,             ->{where(parent_model: "Tenders::Order")},               dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :tender_bill_configs,              ->{where(parent_model: "Tenders::Bill")},                dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :tender_shipment_configs,          ->{where(parent_model: "Tenders::Shipment")},            dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :tender_sale_request_configs,     ->{where(parent_model: "Tenders::SaleRequest")},         dependent: :destroy, class_name: "FileAttributesConfig"

  has_many   :purchase_purchase_request_configs, ->{where(parent_model: "Purchases::PurchaseRequest")},        dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :purchase_budget_configs,          ->{where(parent_model: "Purchases::Budget")},          dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :purchase_surgery_request_configs, ->{where(parent_model: "PurchaseSurgeryRequest")},     dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :purchase_order_configs,           ->{where(parent_model: "Purchases::Order")},           dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :purchase_arrival_configs,         ->{where(parent_model: "Purchases::Arrival")},         dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :purchase_devolution_configs,      ->{where(parent_model: "Purchases::Devolution")},      dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :purchase_bill_configs,            ->{where(parent_model: "Purchases::Bill")},            dependent: :destroy, class_name: "FileAttributesConfig"
  has_many   :purchase_payment_order_configs,   ->{where(parent_model: "Purchases::PaymentOrder")},    dependent: :destroy, class_name: "FileAttributesConfig"

  has_many   :attendance_resumes, dependent: :destroy
  has_many   :attendances, through: :attendance_resumes
  has_many   :attendance_categories
  has_many   :non_working_days
  has_many   :user_vacations, class_name: "UserVacation"
  has_many   :permissions, class_name: "Permission"
  has_many   :work_stations

  has_many   :bills, class_name: "GeneralBill"
  has_many   :budgets, class_name: "ExpedientBudget"
  has_many   :receipts, class_name: "ExpedientReceipt"


  accepts_nested_attributes_for :sale_points, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :banks, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :cards, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :stores, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :departments, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :file_attributes_config, allow_destroy: true, reject_if: :all_blank

  before_save :set_code, if: :new_record?
  before_validation :clear_cuit

  IVA_COND = ["Responsable Inscripto", "Responsable Monotributo", "Exento", "Consumidor final"]
  TIPO_RESPONSABLE = {
    "01" => "Responsable Inscripto",
    "02" => "Responsable no Inscripto",
    "03" => "IVA no Responsable",
    "04" => "Exento",
    "05" => "Consumidor Final",
    "06" => "Responsable Monotributo",
    "07" => "Sujeto no Categorizado",
    "08" => "Importador del Exterior",
    "09" => "Cliente del Exterior",
    "10" => "IVA Liberado ý Ley Ný 19.640",
    "11" => "IVA Responsable Inscripto - Agente de Percepción"
  }

  validates_presence_of :name, message: "El nombre no puede estar en blanco"
  validates_uniqueness_of :name, message: "El nombre ya existe, ingrese otro por favor"

  validates_presence_of :email, message: "El email no puede estar en blanco"
  validates_uniqueness_of :email, message: "El email ya existe, ingrese otro por favor"

  validates_presence_of :society_name, message: "La razón social no puede estar en blanco"
  validates_uniqueness_of :society_name, message: "La razón social ya existe, ingrese otro por favor"

  validates_presence_of :concept, message: "El concepto no puede estar en blanco"
  validates_inclusion_of :concept, in: Afip::CONCEPTOS.values, message: "El concepto es incorrecto"

  validate :presence_of_locality_id

  validate :presence_of_postal_code

  validate :presence_of_address

  validate :date_must_be_in_the_past

  validates_presence_of :currency, message: "Debe ingresar un tipo de moneda"
  validates_inclusion_of :currency, in: Afip::MONEDAS.map{|m, c| c[:codigo] }, message: "Moneda incorrecta"

  validates_length_of :cbu, is: 22, message: "El C.B.U. debe contener 22 dígitos", allow_blank: true
  validates_numericality_of :cbu, message: "El C.B.U. solo puede contener caracteres numéricos", allow_blank: true

  validates_length_of :cuit, is: 11, message: "El C.U.I.T. debe contener 11 dígitos", allow_blank: true

  #validates_presence_of :iva_cond, message: "Debe especificar su condición frente al I.V.A."
  validates_inclusion_of :iva_cond, in: IVA_COND, message: "Condición ante I.V.A. incorrecta", allow_blank: true

  validate :at_least_one_sale_point

  validate :at_least_one_store

  before_save :set_code, if: :new_record?
  after_create :generate_general_cash_account

  #ATRIBUTOS
    def current_view=(value)
      @current_view = value
    end

    def current_view
      @current_view
    end

    def logo
      read_attribute(:logo).blank? ? "/images/default_logo.png" : super
    end

    def pdf_logo
      read_attribute(:pdf_logo).blank? ? "/images/default_logo.png" : super
    end

    def online_sale_points
      AfipBill.new(company: self).get_ptos_vta
    end

    def anmat_type
      read_attribute(:anmat_type) || "DISTRIBUIDORA"
    end

    def families
      fam = inventaries.pluck(:family)
      return nil if fam.uniq.compact.nil?
      fam.uniq.reject(&:blank?)
    end

    def tax_types
      taxes.pluck(:tipo).uniq.map(&:upcase)
    end

    def function_points
      tickets.where(state: ['finished', 'tested'], finish_date: [Date.today.beginning_of_month..Date.today.end_of_month]).where.not(classification: "Error").sum(:function_points)
    end

  #ATRIBUTOS

  #VALIDACIONES

  def date_must_be_in_the_past
    errors.add(:activity_init_date, "La fecha de inicio de actividad no puede ser mayor a #{I18n.l(Date.today)}") unless (self.activity_init_date.blank? || self.activity_init_date <= Date.today)
  end

  def presence_of_locality_id
    errors.add(:locality_id, "Debe seleccionar una localidad") unless (!locality.blank? || current_view != "location")
  end

  def presence_of_postal_code
    errors.add(:postal_code, "Debe ingresar un código postal") unless (!postal_code.blank? || current_view != "location")
  end

  def presence_of_address
    errors.add(:address, "Debe especificar la dirección") unless (!address.blank? || current_view != "location")
  end

  def at_least_one_sale_point
    errors.add(:base, "Debe ingresar al menos un punto de venta") unless (sale_points.size >= 1 || current_view != "sale_points")
  end

  def at_least_one_store
    errors.add(:base, "Debe ingresar al menos un depósito") unless (stores.size >= 1 || current_view != "stores")
  end
  #VALIDACIONES

  #CALLBACKS
    def set_code
      begin
          self.code = SecureRandom.hex(3).upcase
      end while !Company.select(:code).where(:code => code).empty?
    end

    def generate_general_cash_account
      CompanyManager::GeneralCashAccountGenerator.call(self)
    end
  #CALLBACKS

  #BEFORE VALIDATION
    def clear_cuit
      self.cuit.gsub(/\D/, '') unless cuit.blank?
    end
  #BEFORE VALIDATION

  def iva_cond_sym
    iva_cond.parameterize.underscore.gsub(" ", "_").to_sym
  end

  def build_initial_departments
    unless errors.any?
      current_departments = departments.map(&:name)
      Department::DEFAULTS.each{ |name| departments.build(name: name) unless current_departments.include?(name) }
    end
    return departments
  end

  def self.build_initial
    n = (rand(1..100000) * 100).to_i
    company = self.new(
      name: "Compañía #{n}",
      email: "email#{n}@litecode.com",
      society_name: "Nombre registrado #{n}",
      concept: "01",
      locality_id: Locality.first.nil? ? nil : Locality.first.id,
      postal_code: "4400",
      address: "Dirección...",
      activity_init_date: Date.today,
      currency: "PES",
    )
    company.stores.build(name: "Depósito central", location: "Central")
    company.sale_points.build(number: "001")
    company.save!
    return company.id
  end
end
