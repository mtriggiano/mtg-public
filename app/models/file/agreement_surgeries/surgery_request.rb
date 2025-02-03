class AgreementSurgeries::SurgeryRequest < ApplicationRecord
  self.table_name = :surgery_requests
  include Virtus.model(mass_assignment: true, constructor: false)
  include Numerable
  include AASM

  has_paper_trail only: [:aasm_state]

  belongs_to :company
  belongs_to :user, optional:true
  belongs_to :file, optional: true, class_name: 'AgreementSurgeries::File'
  belongs_to :rejected_by, class_name: "User", optional: true
  belongs_to :approved_by, class_name: "User", optional: true
  belongs_to :created_by, class_name: "User", optional: true
  belongs_to :updated_by, class_name: "User", optional: true

  belongs_to :province, optional: true
  belongs_to :locality, optional: true

  has_many :surgery_request_details
  accepts_nested_attributes_for :surgery_request_details, allow_destroy: true

  attribute :current_user, User

  validates :surgery_request_details, presence: { message: "Debe ingresar al menos un Material" }
  validates :number, presence: true
  validates :request_date, presence: true
  validates :surgery_type, presence: true
  validates :surgery_date, presence: true
  validates :observation, presence: false
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthday, presence: false
  validates :age, presence: false
  validates :gender, presence: false
  validates :document_type, presence: true
  validates :document_number, presence: true
  validates :address, presence: false
  validates :mobile_phone, presence: false
  validates :province, presence: false
  validates :locality, presence: false
  validates :social_work, presence: false
  validates :pacient_number, presence: false
  validates :scheduled, presence: false
  validates :medical_history, presence: false
  validates :institution, presence: false
  validates :doctor, presence: false
  validates :internal_stock, presence: false
  validates :anses_negative, presence: false
  validates :dni, presence: false
  validates :surgery_time, presence: true
  validate :surgery_time_not_changed, on: :update

  before_validation :set_default_values
  before_validation :set_estado_inicial, on: :create

  STATES = [
    "ESPERA_DE_APROBACION", # initial state
    "ESPERA_DE_COORDINACION",
    "AROBADA",
    "RECHAZADO"
  ]

  GENEROS = [
    "MASCULINO",
	"FEMENINO"
  ]

  PROGRAMADA = "PROGRAMADA"
  URGENCIA = "URGENCIA / GUARDIA"
  SURGERY_TYPE_OPTIONS = [PROGRAMADA, URGENCIA]

  DEFAULT_FILE = "/images/attachment.png"

  aasm do
    state :espera_aprobacion, initial: true
    state :espera_coordinacion, :aprobada, :rechazada, :espera_procesamiento

    event :a_rechazada do
      transitions from: [:espera_aprobacion, :espera_coordinacion, :espera_procesamiento, :aprobada], to: :rechazada
    end

    event :a_espera_coordinacion do
      transitions from: :espera_aprobacion, to: :espera_coordinacion
    end

    event :a_aprobada do
      transitions from: [:espera_coordinacion, :espera_procesamiento], to: :aprobada
    end

    event :a_espera_aprobacion do
      transitions from: :rechazada, to: :espera_aprobacion, guard: :programada?
    end

    event :a_espera_procesamiento do
      transitions from: :rechazada, to: :espera_procesamiento, guard: :urgencia?
    end
  end

  def to_s
    "#{self.number}"
  end

  def create_file
    file = self.build_file(

      )
    return file
    file.save!
  end

  def set_default_values
    self.document_type = "96"
    self.province = self.locality.province if self.locality
  end

  def set_estado_inicial
    self.aasm_state = :espera_procesamiento if self.urgencia?
  end

  def urgencia?
    self.surgery_time == URGENCIA
  end

  def programada?
    self.surgery_time == PROGRAMADA
  end

  def disabled?
    false
  end

  def valida_para_rechazar?
    errors.add(:reason_for_rejection, "Debe ingresar un motivo de rechazo") unless self.reason_for_rejection.present?
    errors.add(:rejected_by, "Debe ingresar un usuario para rechazar la solicitud") unless self.rejected_by
    return self.errors.count.zero?
  end

  def valida_para_aprobar?
    errors.add(:approved_by, "Debe ingresar un usuario") unless self.approved_by.present?
    if self.programada?
      errors.add(:anses_negative, "Debe cargar el documento Negativa de Anses") unless self.anses_negative.present?
      errors.add(:dni, "Debe cargar el documento DNI") unless self.dni.present?
    end
    return self.errors.count.zero?
  end

  def valida_para_coordinar?
    errors.add(:surgery_date, "Debe ingresar una fecha de cirugia") unless self.surgery_date.present?
    errors.add(:surgical_site, "Debe ingresar un lugar para cirugia") unless self.surgical_site.present?
    errors.add(:doctor, "Debe ingresar un Medico") unless self.doctor.present?
    errors.add(:dni, "Debe cargar el fotocopia de DNI") unless self.dni.present?

    if self.urgencia?
      errors.add(:surgical_sheet, "Debe ingresar Foja quirirjica") unless self.surgical_sheet.present?
      errors.add(:implant_certificate, "Debe ingresar Certificado de implante") unless self.implant_certificate.present?
      if social_work?
  	    errors.add(:anses_no_negative, "Debe ingresar No negativa de anses") unless self.anses_no_negative.present?
  	    errors.add(:codem, "Debe ingresar Informe CODEM") unless self.codem.present?
  	  else
  	    errors.add(:anses_negative, "Debe cargar el documento Negativa de Anses") unless self.anses_negative.present?
  	  end
    else
  	  errors.add(:anses_negative, "Debe cargar el documento Negativa de Anses") unless self.anses_negative.present?
  	  errors.add(:dni, "Debe cargar el documento DNI") unless self.dni.present?
    end

    return self.errors.count.zero?
  end

  def rechazar(user, reason)
    self.rejected_by = user
    self.reason_for_rejection = reason
    return self.valida_para_rechazar? && self.a_rechazada && self.save
  end

  def aprobar(user)
    self.approved_by = user
    return self.valida_para_aprobar? && self.a_espera_coordinacion && self.save
  end

  def coordinar(user)
    return self.valida_para_coordinar? && self.a_aprobada && self.save
  end

  def recuperar(user)
    return self.a_espera_aprobacion && self.save
  end

  def has_pdf?
    false
  end

  def rejeccted?
    self.rejected_by.present?
  end

  def get_anses_no_negative
    self.anses_no_negative || "/images/attachment.png"
  end

  def get_surgical_sheet
    self.surgical_sheet || "/images/attachment.png"
  end

  def get_codem
    self.codem || "/images/attachment.png"
  end

  def get_clinical_record_cover
    self.clinical_record_cover || "/images/attachment.png"
  end

  def get_implant_certificate
    self.implant_certificate || "/images/attachment.png"
  end

  def get_dni
  	self.dni || "/images/attachment.png"
  end

  def get_anses_negative
  	self.anses_negative || "/images/attachment.png"
  end

  def pdf_name
	"Solicitud_#{number}"
  end

  def create_file(_user)
    file = self.build_file
    file.company = self.company
    file.current_user = _user
    file.user = _user
    file.title = "#{self.last_name} #{self.first_name}"
    file.init_date = Date.current
    file.surgery_end_date = self.request_date
    file.client = Client.where(document_number: "30999263158").first
    
    ## customer attributes
    #file.place = self.surgical_site
    #file.detail = self.surgery_type
    #file.doctor = self.doctor
    #file.province = self.province.try(:name)
    #file.pacient = "#{self.last_name} #{self.first_name}"
    #file.pacient_number = self.pacient_number
    #file.external_number = ""
    #file.external_shipment_number = ""
    #file.external_purchase_order_number = ""
    file.request_date = self.request_date
    file.surgery_type = self.surgery_type
    file.surgery_date = self.surgery_date
    file.observation = self.observation
    file.first_name = self.first_name
    file.last_name = self.last_name
    file.birthday = self.birthday
    file.age = self.age
    file.gender = self.gender
    file.document_type = self.document_type
    file.document_number = self.document_number
    file.address = self.address
    file.mobile_phone = self.mobile_phone
    file.phone = self.phone
    file.province = self.province.try(:name)
    file.locality = self.locality.try(:name)
    file.social_work = self.social_work
    file.pacient_number, = self.pacient_number
    file.medical_history = self.medical_history
    file.institution = self.institution
    file.doctor = self.doctor
    file.internal_stock = self.internal_stock
    file.surgery_time = self.surgery_time
    file.nationality = self.nationality

    # custom agreement file attributes
    file.dni = self.dni || DEFAULT_FILE
    file.anses_negative = self.anses_negative || DEFAULT_FILE
    file.anses_no_negative = self.anses_no_negative || DEFAULT_FILE
    file.surgical_sheet = self.surgical_sheet || DEFAULT_FILE
    file.codem = self.codem || DEFAULT_FILE
    file.clinical_record_cover = self.clinical_record_cover || DEFAULT_FILE
    file.implant_certificate = self.implant_certificate || DEFAULT_FILE
    file.father_dni = self.father_dni ||  DEFAULT_FILE
    file.mother_dni = self.mother_dni ||  DEFAULT_FILE
    file.father_anses_negative = self.father_anses_negative ||  DEFAULT_FILE
    file.mother_anses_negative = self.mother_anses_negative ||  DEFAULT_FILE

    return file
  end

  private
  def surgery_time_not_changed
    if surgery_time_changed? && self.persisted?
      errors.add(:surgery_time, "No puede ser editado")
    end
  end

end
