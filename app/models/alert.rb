class Alert < ApplicationRecord
  has_many :alert_users
  has_many :users, through: :alert_users
  belongs_to :company
  belongs_to :alertable, polymorphic: true
  belongs_to :user
  accepts_nested_attributes_for :alert_users, reject_if: :all_blank, allow_destroy: true

  scope :pendings, -> { where(state: "Pendiente")}
  scope :finished, -> { where(state: "Finalizado")}

	STATES = ["Pendiente", "En progreso", "Finalizado", "Anulado"]

  validates_presence_of   :title, message: "La alerta debe tener un título"
  validates_inclusion_of  :state, in: Alert::STATES, message: "Estado inválido"
  validate                :init_date_samaller_than_final_date
  validates_length_of     :observation, maximum: 1000, message: "Observación demasiado extensa"
  validates_length_of     :body, maximum: 5000, message: "Cuerpo demasiado extenso"
  validate                :at_least_one_user

  after_save              :send_notification

  def init_date_samaller_than_final_date
    errors.add(:init_date, "La fecha de inicio no puede ser mayor a la fecha final.") unless init_date <= final_date
  end

  def at_least_one_user
    errors.add(:base, "Debe ingresar al menos un usuario vinculado.") unless alert_users.size > 0
  end

  def send_notification
    if saved_change_to_id?
      set_pending
    elsif saved_change_to_state?
      case state
      when "En progreso"
        set_in_progress
      when "Finalizado"
        set_cumpliment
      when "Anulado"
        set_disable
      end
    end
  end

  def set_pending
    Notification::AlertSender.new(self, nil, users.map(&:id)).for_created
  end

  def set_in_progress
    Notification::AlertSender.new(self, nil, [user.id]).for_in_progress
  end

  def set_cumpliment
    Notification::AlertSender.new(self, nil, [user.id]).for_cumpliment
  end

  def set_disable
    Notification::AlertSender.new(self, nil, [user.id]).for_disable
  end

  def assigned_users
  	AlertUser.where(alert_id: id).map{|ua| ua.user}
	end

  def file
    alertable_type.classify.constantize.find(alertable_id)
  end

  def init_date
    read_attribute(:init_date) || Date.today
  end

  def final_date
    read_attribute(:final_date) || Date.today
  end

  def open?
    ["Finalizado", "Anulado"].include?(state)
  end

  def start_time
    self.init_date
  end
end
