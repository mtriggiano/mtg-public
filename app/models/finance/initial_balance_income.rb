class InitialBalanceIncome < Income
  def descripcion_completa
    descripcion
  end

  def genera_codigo_de_referencia
    self.codigo = "ARQ-#{self.id.to_s.rjust(8,"0")}"
    self.save
  end
end
