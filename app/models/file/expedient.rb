# frozen_string_literal: true

class Expedient < ApplicationRecord
  self.table_name = :files
  has_paper_trail ignore: [:updated_at]
  include Virtus.model(constructor: false, mass_assignment: false)

  SUBSTATES = [
    "INICIAL",
    "COTIZADO",
    "NO COTIZADO",
  	"PENDIENTE DE STICKER",
  	"PENDIENTE DE O.C",
  	"PENDIENTE DE DOCUMENTACION CLÍNICA",
  	"COORDINAR FECHA DE CX",
  	"LISTO PARA ENTREGA",
  	"ENTREGADO",
  	"PERDIDO",
    "CANCELADO"
  ]

  PARTIAL_SHIPMENT_SUBSTATES = [
    "PENDIENTE DE STOCK",
    "PENDIENTE DE ENTREGA",
    "PENDIENTE A COORDINAR",
    "ENTREGA PARCIAL",
    "ENTREGA TOTAL"
  ]

  belongs_to :company
  belongs_to :user
  belongs_to :entity, optional: true
  has_many :expedient_requests,       dependent: :destroy, foreign_key: :file_id
  has_many :expedient_budgets,        dependent: :destroy, foreign_key: :file_id
  has_many :expedient_orders,         dependent: :destroy, foreign_key: :file_id
  has_many :expedient_arrivals,       dependent: :destroy, foreign_key: :file_id
  has_many :expedient_shipments,      ->{where.not(type: ["Surgeries::Consumption"])}, dependent: :destroy, foreign_key: :file_id
  has_many :expedient_consumptions,   dependent: :destroy, foreign_key: :file_id
  has_many :expedient_devolutions,    dependent: :destroy, foreign_key: :file_id
  has_many :expedient_bills,          dependent: :destroy, foreign_key: :file_id
  has_many :expedient_receipts,       dependent: :destroy, foreign_key: :file_id
  has_many :responsables,             dependent: :destroy, foreign_key: :file_id
  has_many :sale_orders,         ->{where(type: ["Sales::Order","Surgeries::SaleOrder","Tender::Order"])}, class_name: "ExpedientOrder", dependent: :destroy, foreign_key: :file_id


  #### attachs

  has_many :expedient_requests_attachs, through: :expedient_requests, source: :attachments
  has_many :expedient_budgets_attachs, through: :expedient_budgets, source: :attachments
  has_many :expedient_orders_attachs, through: :expedient_orders, source: :attachments
  has_many :expedient_consumptions_attachs, through: :expedient_consumptions, source: :attachments
  has_many :expedient_devolutions_attachs, through: :expedient_devolutions, source: :attachments
  has_many :expedient_shipments_attachs, through: :expedient_shipments, source: :attachments
  has_many :expedient_arrivals_attachs, through: :expedient_arrivals, source: :attachments
  has_many :expedient_bills_attachs, through: :expedient_bills, source: :attachments
  has_many :expedient_receipts_attachs, through: :expedient_receipts, source: :attachments

  has_many :file_movements, -> { order(:created_at) }, class_name: 'ExpedientMovement', dependent: :destroy, foreign_key: :file_id
  has_many :departments, through: :file_movements
  #has_many :binnacles, -> {order(:date)}, class_name: "ExpedientBinnacle", dependent: :destroy, foreign_key: :file_id

  store_accessor :custom_attributes,
    :external_number,
    :external_purchase_order_number,
    :external_shipment_number,
    :pacient,
    :detail,
    :pacient_number,
    :province,
    :doctor,
    :place,
    :date,
    :shipping,
    :implant_certificate,
    :implant_original_filename,
    :surgical_sheet,
    :surgical_sheet_original_filename,
    :surgical_sheet_2,
    :surgical_sheet_original_filename_2,
    :note,
    :note_original_filename,
    :sticker,
    :sticker_original_filename,
    :pliego,
    :pliego_original_filename,
    :generated_by_system

  accepts_nested_attributes_for :responsables, reject_if: proc { |fr| fr['user_id'].blank? }, allow_destroy: true
  attribute :current_user, User

  before_validation       :set_attachment_states

  validates_presence_of   :number, message: 'El número de expediente no puede estar en blanco', if: proc {|a| a.type != "Surgeries::File"}
  validates_length_of     :number, maximum: 20, message: 'Número de expediente demasiado largo. Máximo 20 caracteres'
  validates_uniqueness_of :number, scope: [:company_id, :type, :active], message: "Ya existe un expediente con esa numeración", case_sensitive: false

  validates_presence_of   :title, message: 'El título de expediente no puede estar en blanco'
  validates_length_of     :title, maximum: 100, message: 'Título demasiado largo. Máximo 50 caracteres'

  validates_presence_of   :init_date, message: 'La fecha de inicio del expediente no puede estar en blanco'
  validate                :date_format

  validates_presence_of   :user_id, message: 'Debe asignar un responsable'
  validate                :owner_belongs_to_company


  after_create            :notify_users
  after_save              :close_file, :send_alert
  after_save              :create_first_movement, on: :create

  scope :unfinished, -> { where.not(state: 'Finalizado') }
  scope :opened, -> { where(open: true).where.not(state: 'Finalizado') }

  enum implant_state: [:warning, :success, :danger], _prefix: :implant
  enum surgical_sheet_state: [:warning, :success, :danger], _prefix: :surgical_sheet
  enum surgical_sheet_state_2: [:warning, :success, :danger], _prefix: :surgical_sheet_2

  def self.search(search)
    if !search.blank?
      where('LOWER(title) ILIKE LOWER(:cond) OR number LIKE :cond', cond: "%#{search}%")
    else
      all
    end
  end

  def send_alert
    unless saved_change_to_id?
      ::Notification::Expedient.new(current_user, self).for_calendar_change if saved_change_to_surgery_end_date? || saved_change_to_place? || saved_change_to_delivery_date? || saved_change_to_delivery_hour?
      ::Notification::Expedient.new(current_user, self).for_attachment_change if saved_change_to_implant_certificate? || saved_change_to_surgical_sheet?
    end
  end

  def saved_change_to_place?
    saved_changes["custom_attributes"]&.first.try(:[],"place") != saved_changes["custom_attributes"]&.last.try(:[],"place")
  end

  def saved_change_to_implant_certificate?
    saved_changes["custom_attributes"]&.first.try(:[],"implant_certificate") != saved_changes["custom_attributes"]&.last.try(:[],"implant_certificate")
  end

  def saved_change_to_surgical_sheet?
    saved_changes["custom_attributes"]&.first.try(:[],"surgical_sheet") != saved_changes["custom_attributes"]&.last.try(:[],"surgical_sheet")
  end

  def set_attachment_states
    self.implant_state ||= 'warning'
    self.surgical_sheet_state ||= 'warning'
  end

  def implant_certificate
    super || "/images/attachment.png"
  end

  def surgical_sheet
    super || "/images/attachment.png"
  end

  def surgical_sheet_2
    super || "/images/attachment.png"
  end

  def note
    super || "/images/attachment.png"
  end

  def sticker
    super || "/images/attachment.png"
  end

  def pliego
    super || "/images/attachment.png"
  end

  def full_name
    "Nº #{number} - #{title.titleize}"
  end

  def attachments
    # Attachment
    # .joins("LEFT OUTER JOIN requests on attachments.attachable_id = requests.id AND attachments.attachable_type = 'ExpedientRequest' LEFT OUTER JOIN files r_files ON requests.file_id = #{id}")
    # .joins("LEFT OUTER JOIN budgets on attachments.attachable_id = budgets.id AND attachments.attachable_type = 'ExpedientBudget' LEFT OUTER JOIN files b_files ON budgets.file_id = #{id}")
    # .joins("LEFT OUTER JOIN orders on attachments.attachable_id = orders.id AND attachments.attachable_type = 'ExpedientOrder' LEFT OUTER JOIN files o_files ON orders.file_id = #{id}")
    # .joins("LEFT OUTER JOIN devolutions on attachments.attachable_id = devolutions.id AND attachments.attachable_type = 'ExpedientDevolution' LEFT OUTER JOIN files d_files ON devolutions.file_id = #{id}")
    # .joins("LEFT OUTER JOIN bills on attachments.attachable_id = bills.id AND attachments.attachable_type = 'ExpedientBill' LEFT OUTER JOIN files bi_files ON bills.file_id = #{id}")
    # .joins("LEFT OUTER JOIN arrivals on attachments.attachable_id = arrivals.id AND attachments.attachable_type = 'ExpedientArrival' LEFT OUTER JOIN files a_files ON arrivals.file_id = #{id}")
    # .joins("LEFT OUTER JOIN shipments on attachments.attachable_id = shipments.id AND attachments.attachable_type IN ('ExpedientShipment', 'ExpedientConsumption') LEFT OUTER JOIN files s_files ON shipments.file_id = #{id}")
    # .where("r_files.id = :id OR b_files.id = :id OR o_files.id = :id OR d_files.id = :id OR bi_files.id = :id OR a_files.id = :id OR s_files.id = :id", id: id)
    attachs = expedient_requests_attachs + expedient_budgets_attachs + expedient_orders_attachs + expedient_devolutions_attachs + expedient_bills_attachs + expedient_arrivals_attachs + expedient_shipments_attachs + expedient_consumptions_attachs + expedient_receipts_attachs
  end

  def notify_users
    ::Notification::Expedient.new(current_user, self).for_created unless generated_by_system
  end

  def alerts(user)
    ManageAlert.new(parent: self, user: user, parent_object_id: id, object_class: self.class.name).display
  end

  def disabled?
    !self.open && errors.empty?
  end

  def date_format
    unless init_date.respond_to?(:to_date)
      errors.add(:init_date, 'Fecha incorrecta')
       end
    unless finish_date.respond_to?(:to_date) || finish_date.blank?
      errors.add(:finish_date, 'Fecha incorrecta')
       end
  end

  def owner_belongs_to_company
    if user
      unless company_id == user.company_id
        errors.add(:user_id, 'Usuario incorrecto')
      end
    end
  end

  def set_next_state
    i = self.class::STATES.index(state) + 1
    update(state: self.class::STATES[i]) if self.class::STATES[i]
    NotificationMaker.new(file: self).for_file_new_state
  end

  def create_first_movement
    if saved_change_to_id?
      file_movements.create(
        file_type: self.class.name,
        department_id: initial_department,
        sended_by: user_id,
        received_by: user_id,
        sended_at: Time.now,
        received_at: Time.now,
      )
    end
  end

  def close_file
    if saved_change_to_state? && state == 'Finalizado'
      update_column(:open, false)
       end
  end

  def start_time
    finish_date
  end

  def self.closest_file
    where("finish_date >= :date", date: Date.today).order("finish_date ASC").first
  end

  def file_type_abbr
    case type
    when "Sales::File"
      "V: "
    when "Surgeries::File"
      "CX: "
    when "Tenders::File"
      "L: "
    end
  end

  def has_shipments_color
    if expedient_shipments.any?
      expedient_shipments.approveds.count == expedient_shipments.count ? "green" : "orange"
    else
      "red"
    end
  end
end
