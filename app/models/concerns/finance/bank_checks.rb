module Finance::BankChecks
  extend ActiveSupport::Concern

  def full_name
    "#{self.numero} - Monto: $#{self.monto}"
  end

  def start_time
    read_attribute(:fecha_pago) || Date.today
  end
end
