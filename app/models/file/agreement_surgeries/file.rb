class AgreementSurgeries::File < Expedient
  include Numerable
  validates_presence_of :number, message: "Debe especificar"

  belongs_to :client, foreign_key: :entity_id
  belongs_to :entity

  has_one :surgery_request
  has_many :sale_orders, class_name: 'AgreementSurgeries::SaleOrder', foreign_key: :file_id, dependent: :destroy, inverse_of: :file
  has_many :budgets, class_name: 'AgreementSurgeries::Budget', foreign_key: :file_id, dependent: :destroy
  has_many :shipments, class_name: 'AgreementSurgeries::Shipment', foreign_key: :file_id, dependent: :destroy

  validates :surgery_request, presence: true

  before_create :set_initial_state

  TYPES = ['Convenio Cirugía'].freeze
  STATES = SUBSTATES + [
    'En espera de receta',
    'En espera de cotización',
    'En espera de orden de venta',
    'En espera de presupuesto de proveedor',
    'En espera de llegada de stock',
    'En espera de salida de stock',
    'En espera de registro de consumo',
    'En espera de orden de compra',
    'En espera de facturación',
    'Finalizado'
  ].map(&:upcase)

  store_accessor :custom_attributes,
	  :request_date,
	  :surgery_type,
	  :surgery_date,
	  :observation,
	  :first_name,
	  :last_name,
	  :birthday,
	  :age,
	  :gender,
	  :document_type,
	  :document_number,
	  :address,
	  :mobile_phone,
	  :phone,
	  :province,
	  :locality,
	  :social_work,
	  :pacient_number,
	  :scheduled,
	  :medical_history,
	  :institution,
	  :doctor,
	  :internal_stock,
	  :surgery_time,
    :nationality,
	  :dni,
    :anses_negative,
    :anses_no_negative,
    :surgical_sheet,
    :surgical_sheet_2,
    :codem,
    :clinical_record_cover,
    :implant_certificate,
    :father_dni,
    :mother_dni,
    :father_anses_negative,
    :mother_anses_negative

  private
  def set_initial_state
    self.state = 'Espera de coordinacion'
  end
end