class Checkbook < ApplicationRecord
  belongs_to :bank_account

  has_many :emitted_checks

  validates_presence_of :number, :bank_account_id, :serie, :init_number, :final_number
  validates_numericality_of :number, greater_than: 0, message: "Debe ser mayor a 0"
  validates_numericality_of :init_number, greater_than: 0, message: "Debe ser mayor a 0"
  validate :numeracion

  def nombre
    "#{self.number} - Serie: #{self.serie}"
  end

  def get_next_number
    ultimo_numero = self.emitted_checks.maximum(:numero)
    if ultimo_numero.nil?
      ultimo_numero = self.init_number
    end
    numero = ultimo_numero + 1
    return nil if numero > self.final_number
    return numero
  end

  def numeracion
    errors.add(:final_number, "El número final debe ser mayor a la numeración inicial") unless final_number.to_i > init_number.to_i
  end
end
