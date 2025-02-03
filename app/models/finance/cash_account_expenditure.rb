# Representa: Gastos de caja (siempre asociado a una caja)
#
class CashAccountExpenditure < ExpenseDetail
  belongs_to :cash_account
  has_one   :expenditure_expense, as: :spendable, dependent: :destroy, foreign_key: :spendable_id

  validates_presence_of :cash_account

  after_validation :set_numero_de_recibo

  validate :only_business_day

  def only_business_day
    errors.add(:fecha, "Solo se puede registrar en dias laborales.") if [6,0].include? fecha&.to_date&.wday
    errors.add(:fecha_registro, "Solo se puede registrar en dias laborales.") if [6,0].include? fecha_registro&.to_date&.wday
  end

  def codigo_recibo
    "GC-#{numero_de_recibo.to_s.rjust(8, "0")}"
  end

  private

  def set_numero_de_recibo
    unless numero_de_recibo.present?
      numero = CashAccountExpenditure.where(cash_account_id: self.cash_account_id).where.not(numero_de_recibo: nil).order(numero_de_recibo: :desc).first_or_initialize.numero_de_recibo
      numero ||= 0
      self.numero_de_recibo = numero + 1
    end
  end

  def self.search data
    return all if data.blank?
    where("
      numero_de_recibo::text LIKE :data OR
      LOWER(letra) LIKE :data OR
      LOWER(descripcion) LIKE :data OR
      LOWER(supplier_name) LIKE :data OR
      total::text LIKE :data
    ", data: "%#{data.downcase}%")
  end
end
