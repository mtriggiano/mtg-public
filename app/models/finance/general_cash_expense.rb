class GeneralCashExpense < Expense
  def descripcion_completa
    texto = self.descripcion
    texto.prepend("#{self.lugar} - ") unless self.lugar.blank?
    return texto
  end

  def genera_codigo_de_referencia
    if self.codigo.blank?
      self.codigo = "G-#{self.id.to_s.rjust(8,"0")}"
      self.save
    end
  end
end
