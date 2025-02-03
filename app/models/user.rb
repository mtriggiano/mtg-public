class User < ApplicationRecord
  belongs_to :locality, optional: true
  belongs_to :company, optional: true
  belongs_to :store, optional: true
  belongs_to :work_station, optional: true

  has_and_belongs_to_many :alerts, dependent: :destroy
  has_and_belongs_to_many :roles

  has_many :permissions, through: :roles, source: :abilities
  has_many :notifications, dependent: :destroy
  has_many :responsables, class_name: 'Responsable', foreign_key: :user_id, dependent: :destroy
  has_many :table_configs, class_name: 'UserTableConfig', dependent: :destroy
  has_many :cash_solicitudes
  has_many :activities, dependent: :destroy
  has_many :files, dependent: :destroy, class_name: 'Expedient'
  has_many :attendances
  has_many :attendance_resumes
  has_many :resume_attendances, class_name: 'Attendance', through: :attendance_resumes, source: :attendances
  has_many :attendance_category_users, dependent: :destroy
  has_many :attendance_categories, through: :attendance_category_users
  has_many :non_working_day_details
  has_many :non_present_users
  has_many :excluded_non_working_days, through: :non_working_day_details, class_name: 'NonWorkingDay'
  has_many :user_vacations, class_name: 'UserVacation', dependent: :destroy
  has_many :debt_vacations, class_name: 'UserDebtVacation', dependent: :destroy
  has_one :user_comission_limit, dependent: :destroy
  has_many :user_comission_rewards, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :surgery_requests, dependent: :destroy

  delegate :can?, :cannot?, to: :ability

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :invitable, invite_for: 2.weeks
  accepts_nested_attributes_for :roles, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :debt_vacations, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :attendance_category_users, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :user_comission_limit, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :user_comission_rewards, reject_if: :all_blank, allow_destroy: true

  before_validation :check_company_id, if: :new_record?
  before_validation :create_with_company, if: :new_record?

  validates_presence_of :company_id, message: 'Debe estar vinculado a una compañía.'
  validates_uniqueness_of :email, message: 'El usuario ya esta registrado.'
  validates_uniqueness_of :machine_id, message: 'El ID de Biométrico debe ser único. Ya existe otro usuario con este ID', allow_blank: true

  scope :actives, -> { where(active: true) }
  scope :by_search, ->(search) { where('email ILIKE :search OR first_name ILIKE :search OR last_name ILIKE :search', search: "%#{search}%") }

  CONTRACTS = ['Planta permanente', 'A prueba', 'Pasantía', 'Plazo fijo', 'Por temporada', 'Tiempo indeterminado', 'Otros']

  # Verifica si el usuario tiene alguno de los permisos dados
  def has_any_permission?(*permissions)
    permissions.any? { |permission| has_permission?(permission) }
  end

  # Método para verificar permisos de reportes
  def has_permission?(permission_key)
    permission_class = if permission_key.to_s == "all_reports"
                         "Reports::AllReports"
                       elsif permission_key.to_s.start_with?("reports")
                         "Reports::#{permission_key.to_s.sub('reports_', '').classify}"
                       else
                         permission_key.to_s.classify
                       end
  
    roles.includes(:abilities).any? do |role|
      role.abilities.any? do |ability|
        puts "Comparando: #{ability.class_name} con #{permission_class}"
        ability.class_name == permission_class
      end
    end
  end

  # Método para inicializar la habilidad del usuario
  def ability
    Ability.new(self)
  end

  # Métodos existentes de roles
  def is_a_company_owner?
    company_owner
  end

  def is_an_admin?
    admin
  end

  # Nuevo método `has_role?` para verificar si un usuario tiene un rol específico
  def has_role?(role_name)
    roles.exists?(name: role_name.to_s)
  end

  # Método para obtener el nombre completo del usuario o su correo si no está disponible
  def name
    n = "#{first_name} #{last_name}"
    n.blank? ? email : n
  end

  # Atributos de roles
  def roles_attributes=(attributes)
    attributes.each do |num, attribute|
      unless attribute['role_id'].blank?
        new_role = roles.where(role_id: attribute['role_id'].to_i).first_or_initialize
        new_role.abilities.map { |a| a.mark_for_destruction unless attribute['ability_ids'].include?(a.role_ability_id.to_s) }
        attribute['ability_ids'].each do |ability_id|
          new_role.abilities.where(role_ability_id: ability_id).first_or_initialize unless ability_id.blank?
        end
        new_role.save
      end
    end
  end

  # Proceso y validaciones relacionadas
  def assign_company(company_id)
    update_column(:company_id, company_id)
  end

  def set_medic_role
    role = Role.find_by(friendly_name: 'Solicitudes de Bancos')
    user_role = roles.where(user_id: id, role_id: role.id, active: true).first_or_initialize
    role.abilities.each do |ability|
      user_role.abilities.where(role_ability_id: ability.id).first_or_initialize
    end
    user_role.save
  end

  def check_company_id
    company_owner = company_id.blank?
  end

  def create_with_company
    unless company
      self.company_id = Company.build_initial
      self.approved = true
      self.company_owner = invitation_created_at.blank?
    end
  end

  # Funciones relacionadas con notificaciones y alertas
  def count_notifications
    notifications.unseen.count
  end

  def pending_alerts
    alerts.pendings.count
  end

  def finalized_alerts
    alerts.finished.count
  end

  # Funciones adicionales para permisos y visibilidad
  def permitted_payment_types
    if is_an_admin? || is_a_company_owner? || can?(:manage, GeneralCashAccountPayment)
      company.payment_types
    else
      company.payment_types.reject { |a| a.cash_account_id == 3 }
    end
  end

  def can_see_all_sellers
    is_an_admin? || is_a_company_owner? || can?(:manage, SellerBill)
  end

  # Cálculo de horas esperadas mensuales
  def expected_monthly_hours(first_date, last_date, non_working_days)
    emh = 0
    att_categories = attendance_categories
    unless non_working_days.nil?
      user_non_working_days = non_working_days.map { |a| a if a.users.map { |b| b.id }.include?(id).blank? }.compact
    end

    emh = if !att_categories.blank?
            emh_with_category(att_categories, first_date, last_date, user_non_working_days)
          else
            emh_with_no_category(first_date, last_date, user_non_working_days)
          end
    emh
  end

  def emh_with_category(att_categories, first_date, last_date, user_non_working_days)
    emh = 0
    (first_date.to_date..last_date.to_date).each do |date|
      next if user_non_working_days.map { |nw| nw.date }.include?(date)
      emh += if date.wday == 6 # Sábado
               4
             elsif date.wday == 0 # Domingo
               0
             else
               8
             end
    end
    emh
  end

  def emh_with_no_category(first_date, last_date, user_non_working_days)
    emh = 0
    (first_date.to_date..last_date.to_date).each do |date|
      next if user_non_working_days.map { |nw| nw.date }.include?(date.to_date)
      emh += if date.wday == 6 # Sábado
               4
             elsif date.wday == 0
               0
             else
               8
             end
    end
    emh
  end

  def check_if_comission_objective
    if user_comission_limit.nil?
      return 'No', 0
    else
      init_date, final_date = user_comission_limit.period_date
      orders = Sales::Bill.joins(:orders, orders: [details: :user]).where(state: 'Confirmado').where('DATE(bills.cbte_fch) BETWEEN ? AND ?', init_date, final_date).where(order_details: { user_id: id }).distinct
      if orders.blank?
        'No'
      else
        orders_total = (orders.sum(:total) * company.coefficient_for_net_amount).round(2)
        if user_comission_rewards.blank?
          "Sin premio definido, Total facturado: $#{orders_total}"
        else
          premio = user_comission_rewards.order(:percentage).map { |a| "Porcentaje: #{a.percentage} - Premio: $#{(a.amount_percentage_float * orders_total).round(2)}" if ((user_comission_limit.amount * a.percentage_float) <= orders_total) }.compact.first
          unless premio.nil?
            "Si, #{premio}, Total facturado: $#{orders_total}"
          else
            "No, Total facturado: $#{orders_total}"
          end
        end
      end
    end
  end
end
