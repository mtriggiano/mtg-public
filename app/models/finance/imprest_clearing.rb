class ImprestClearing < ApplicationRecord
  belongs_to :user
  belongs_to :general_cash_account, class_name: "GeneralCashAccount", foreign_key: :general_cash_account_id
  belongs_to :regular_cash_account, class_name: "RegularCashAccount", foreign_key: :regular_cash_account_id

  include Finance::CordersCounter ## contador de monedas

  validates_presence_of :fecha, message: "Debe ingresar la fecha."
  validates :fondo_fijo,
    presence: { message: "Debe ingresar el monto del Fondo Fijo ($)." },
    numericality: { greater_than_or_equal_to: 0, message: "El monto del Fondo Fijo debe ser mayor a $0." }
  validates :saldo_inicio,
    presence: { message: "Debe ingresar el monto del Saldo de Inicio ($)." },
    numericality: { greater_than_or_equal_to: 0, message: "El monto del Saldo de Inicio debe ser mayor a $0." }
  validates :a_rendir,
    presence: { message: "Debe ingresar el monto del Saldo a Rendir ($)." },
    numericality: { greater_than_or_equal_to: 0, message: "El monto del Saldo a Rendir debe ser mayor a $0." }
  validates :saldo_en_caja,
    presence: { message: "Debe ingresar el monto del Saldo en Caja ($)." },
    numericality: { greater_than_or_equal_to: 0, message: "El monto del Saldo en Caja debe ser mayor a $0." }
  validate :restriccion_fondo_fijo
  validate :saldo_en_caja_y_a_rendir
  validate :only_business_day

  scope :confirmados, -> { where.not(tiempo_de_confirmacion: nil) }
  scope :daily, ->(fecha) { where(fecha: fecha) }

  def self.search data
    return all if data.blank?
    includes(:general_cash_account, :regular_cash_account, :user).references(:user, :general_cash_account, :regular_cash_account).where("imprest_clearings.id::text = :data OR LOWER(cash_accounts.nombre) LIKE :data OR LOWER(users.first_name || ' ' || users.last_name) LIKE :data", data: "%#{data.downcase}%")
  end

  def only_business_day
    errors.add(:base, "Solo se puede registrar en dias laborales.") if [6,0].include? fecha.to_date.wday
  end

  def pendiente?
    tiempo_de_confirmacion == nil
  end

  def fecha
    super || Time.now
  end

  def confirmado?
    tiempo_de_confirmacion != nil
  end

  def confirmar!
    update_columns(tiempo_de_confirmacion: DateTime.now)
  end

  private

  def restriccion_fondo_fijo
    errors.add(:saldo_en_caja, "El saldo en caja debe ser menor al fondo fijo ingresado.") if saldo_en_caja > fondo_fijo
  end

  def saldo_en_caja_y_a_rendir
    unless self.confirmado?
      rendiciones_anteriores = regular_cash_account.imprest_clearings.confirmados.order(:tiempo_de_confirmacion)
      if rendiciones_anteriores.blank?
        transacciones = regular_cash_account.logs.efectivo_pesos
      else
        transacciones = regular_cash_account.logs.efectivo_pesos.where("created_at BETWEEN ? AND ?", rendiciones_anteriores.last.tiempo_de_confirmacion, (self.fecha + 1.days))
      end
      saldo_pesos = transacciones.incomes.efectivo_pesos.pluck(:monto).inject(0, :+)
      saldo_pesos = transacciones.expenses.efectivo_pesos.pluck(:monto).inject(saldo_pesos, :-)

      saldo_informado = self.saldo_en_caja + self.a_rendir

      errors.add(:base, "La suma de 'Importe a rendir' y 'Saldo en caja' debe ser igual a $ #{saldo_pesos.to_i}. Suma actual: $ #{saldo_informado.to_i}.") if saldo_informado.to_i != saldo_pesos.to_i
    end
  end
end
