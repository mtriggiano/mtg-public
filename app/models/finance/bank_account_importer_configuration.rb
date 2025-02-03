class BankAccountImporterConfiguration < ApplicationRecord
  belongs_to :bank_account

  validates_presence_of :fecha, :descripcion, :credito, :debito, :saldo, :amount
  validates_numericality_of :fecha, :descripcion, :credito, :debito, :saldo, :amount, greater_or_equal_than: 0, message: "El valor de posición ingresado es incorrecto."
  validate :posiciones_diferentes


  def posiciones_diferentes
    vector_posiciones = []
    vector_posiciones << self.fecha unless self.fecha == 0
    vector_posiciones << self.descripcion unless self.descripcion == 0
    vector_posiciones << self.credito unless self.credito == 0
    vector_posiciones << self.debito unless self.debito == 0
    vector_posiciones << self.saldo unless self.saldo == 0
    vector_posiciones << self.amount unless self.amount == 0
    errors.add(:base, "Las posiciones de las columnas no pueden repetirse.") if vector_posiciones.uniq.length != vector_posiciones.length
  end

  def vector_posiciones
    [self.fecha, self.description, self.credito, self.debito, self.saldo, self.amount].reject{|a| a == 0}.sort_by{|a| a}.uniq
  end
end
