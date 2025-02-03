class Ticket < ApplicationRecord
  include Virtus.model(constructor: false, mass_assignment: false)
  belongs_to :company
  belongs_to :user
  has_many :comments, as: :articleable
  attribute :current_user, User
  before_save :can_update?
  before_save :set_date
  before_save :set_permitted_attributes
  before_validation :set_company
  scope :pendings, ->{where(state: 'pending')}
  scope :approveds, ->{where(state: 'approved')}
  scope :finished, ->{where(state: 'finished')}
  accepts_nested_attributes_for :comments, reject_if: :body_blank?, allow_destroy: true

  STATES = {
    pending: "Pendiente",
    started: "Iniciado",
    approved: "Aprobado",
    rejected: "Rechazado",
    finished: "Finalizado",
    tested: "Testeado",
    failed: "Con fallas"
  }

  TYPES = ["Mejora", "Error", "Adaptación", "Otro"]

  AREAS = ["Pago a proveedores", "Ventas", "Logística", "Finanzas", "RRHH"]

  def can_update?
    unless new_record? || current_user.admin? || current_user.company_owner || current_user.id = user.id
      throws :abort
    end
  end

  def set_permitted_attributes
    unless current_user.admin?
      if current_user.company_owner
        self.restore_attributes([:function_points, :init_date, :finish_date])
      elsif current_user.id = user_id
        self.restore_attributes([:function_points, :init_date, :finish_date, :state])
      end
    end
  end

  def set_company
    self.company_id ||= user.company_id
  end

  def self.humanized_state search
    value = STATES.values.map(&:downcase).grep(/^#{search.downcase}/).first
    STATES.rassoc(value.to_s.capitalize).try(:first)
  end

  def attachment
    read_attribute(:attachment) || "/images/default_product.png"
  end

  def comments_attributes=(attributes)
    attributes["0"]["user_id"] = current_user.id
    super
  end

  def body_blank?(att)
    att['body'].blank?
  end

  def can_start?
    if state == "approved"
      true
    else
      false
    end
  end

  def can_finish?
    if state == "approved" || state == "started" || state == "failed"
      true
    else
      false
    end
  end

  def finished?
    state == "finished"
  end

  def set_date
    if state_changed? && finished?
      self.date = Date.today
    else
      self.date = nil
    end
  end

end
