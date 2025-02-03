class Tenders::SupplierBudgetPresenter < TenderApplicationPresenter
  	presents :budget

	def init_date
		handle_date(budget.init_date)
	end

	def final_date
		handle_date(budget.final_date)
	end

	def state
		case budget.state
		when "Pendiente"
			span = 'warning'
		when "Aprobado"
			span = 'success'
		when "Reformular"
			span = 'primary'
		when "Rechazado"
			span = 'dark'
		end
		super(span, budget.state)
	end
end
