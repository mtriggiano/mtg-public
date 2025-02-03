class GeneralCashIncome < Income

  validate :only_business_day

  def only_business_day
    errors.add(:fecha, "Solo se puede registrar en dias laborales.") if [6,0].include? fecha.to_date.wday
  end

  def descripcion_completa
    texto = self.descripcion
    texto.prepend("#{self.lugar} - ") unless self.lugar.blank?
    return texto
  end

  def genera_codigo_de_referencia
    if self.codigo.blank?
      self.codigo = "I-#{self.id.to_s.rjust(8,"0")}"
      self.save
    end
  end
end
