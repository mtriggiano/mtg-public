# Representa: Gastos generales que no impactan en caja (asociados a la empresa pero no pagados por ella)
class Expenditure < ExpenseDetail
  belongs_to :company

  def codigo_recibo
    "GC-#{numero_de_recibo.to_s.rjust(8, "0")}"
  end
end
