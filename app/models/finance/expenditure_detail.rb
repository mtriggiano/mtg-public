class ExpenditureDetail < ExpenseDetail
  belongs_to :cash_solicitude

  #validate :max_total

  def max_total
    importe_retiro = self.cash_solicitude.cash_withdrawal.importe.to_f
    total_actual = self.cash_solicitude.expense_details.sum(:total).to_f
    if self.new_record?
      errors.add(:total, "El total del importe es mayor al total ingresado") if importe_retiro < (total_actual + self.total)
    else
      errors.add(:total, "El total del importe es mayor al total ingresado") if importe_retiro < (self.cash_solicitude.expense_details.where.not(id: self.id).sum(:total).to_f + self.total)
    end
  end
end
