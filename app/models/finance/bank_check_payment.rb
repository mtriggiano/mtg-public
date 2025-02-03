# Autor: Ariel Agustín García Sobrado
#
# Responsabilidad: Representa los cheques recibidos (en cartera)
#
class BankCheckPayment < PromissoryPayment
  belongs_to :old_bank_check, class_name: "BankCheckPayment", optional: true, foreign_key: :old_bank_check_id

  has_one :new_bank_check, class_name: "BankCheckPayment", foreign_key: :old_bank_check_id

  validate :only_business_day

  def only_business_day
    errors.add(:created_at, "Solo se puede registrar en dias laborales.") if [6,0].include? Date.today.wday
  end

  def payment_type
    "Cheque"
  end
end
