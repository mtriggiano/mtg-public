# Autor: Ariel Agustín García Sobrado
#
# Responsabilidad: Registrar solicitudes y retiros de dinero para realizar actividades (laborales) fuera de la empresa.
#
# Criterios:
#  - Una solicitud puede ser realizada por un usuario o por un agente externo (sin usuario).
#  - Solicitudes sujetas a evaluación por parte del tesorero.
#  - Una solicitud queda abierta hasta que se registra su rendición correspondiente
#
class CashSolicitude < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :company
  belongs_to :evaluador, foreign_key: 'evaluador_id', class_name: 'User', optional: true

  has_one   :cash_withdrawal, dependent: :destroy
  has_one   :withdrawal_expense, as: :spendable, dependent: :destroy, foreign_key: :spendable_id
  has_one   :cash_refund, dependent: :destroy
  has_one   :cash_refund_income, as: :spendable, dependent: :destroy, foreign_key: :spendable_id
  has_many  :expense_details, class_name: "ExpenditureDetail", dependent: :destroy

  accepts_nested_attributes_for :expense_details, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :cash_refund, reject_if: :all_blank, allow_destroy: true

  ESTADOS = %w(Pendiente Aprobado Anulado Entregado Listo)

  before_validation :estado_inicial, on: :create

  validates_presence_of :motivo, message: "Ingrese el motivo de la solicitud."
  validates_presence_of :fecha, message: 'Ingrese la fecha estimada para el retiro de fondos.'
  validates_inclusion_of :estado, in: ESTADOS
  validate :fecha_en_el_futuro, on: :create
  validate :only_business_day

  after_create :genera_codigo

  scope :activas, -> { where(active: true) }
  scope :daily, ->(fecha) { where(fecha: fecha) }
  scope :aprobadas, -> { where(evaluacion: true, estado: "Aprobado") }
  scope :rechazadas, -> { where(evaluacion: false) }
  scope :pendientes, -> { activas.where(evaluacion: nil) }
  scope :user_view, -> { eager_load(:cash_withdrawal).where("(cash_withdrawals.id IS null AND (cash_solicitudes.evaluacion != false OR cash_solicitudes.evaluacion IS null)) OR (cash_withdrawals.fecha BETWEEN ? and ?)", Date.today - 20.days, Date.today) }
  scope :rendiciones_pendientes, -> { activas.joins(:cash_withdrawal).where(estado: "Entregado") }

  def fecha_en_el_futuro
    errors.add(:fecha, "La fecha de la solicitud no puede ser en el pasado.") if fecha? && fecha < Date.today
  end

  def only_business_day
    errors.add(:fecha, "Solo se puede registrar en dias laborales.") if [6,0].include? fecha.to_date.wday
  end

  def self.search data
    return all if data.blank?

    includes(:user).references(:user).where("
      LOWER(codigo) LIKE :data OR
      LOWER(motivo) LIKE :data OR
      LOWER(users.first_name || ' ' || users.last_name) LIKE :data OR
      LOWER(users.email) LIKE :data OR
      monto_aprobado::text LIKE :data
      ", data: "%#{data.downcase}%")
  end

  def estado_inicial
    self.estado = "Pendiente"
  end

  def genera_codigo
    self.codigo = "SF-#{self.id.to_s.rjust(8,"0")}"
    self.save
  end

  def aprobar!
    update_columns(estado: "Aprobado")
  end

  def rechazar!
    update_columns(estado: "Anulado")
  end

  def entregar!
    update_columns(estado: "Entregado")
  end

  def finalizar!
    update_columns(estado: "Listo")
  end

  def finalizado?
    estado == "Listo"
  end

  def editable?
    estado == "Pendiente"
  end
end
