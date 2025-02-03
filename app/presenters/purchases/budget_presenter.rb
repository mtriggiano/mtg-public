class Purchases::BudgetPresenter < PurchaseApplicationPresenter
  	presents :budget
    delegate :init_date, to: :budget
    delegate :final_date, to: :budget

  	def number
  		link_to budget.number, edit_purchases_budget_path(budget.id)
  	end

	def delivery_date
		if budget.delivery_date.blank?
			"Sin especificar"
		else
			I18n.l(budget.delivery_date, format: :short)
		end
	end

	def state
		case budget.state
		when "Pendiente"
			span = 'warning'
		when "Aprobado"
			span = 'success'
		when "En revisión"
			span = 'primary'
		when "Rechazado"
			span = 'dark'
		end

		super(span, budget.state)
	end

	def action_links
		content_tag :div do
			concat(link_to_edit [:edit, @object])
			concat(link_to_destroy @object)
		end
	end
end
