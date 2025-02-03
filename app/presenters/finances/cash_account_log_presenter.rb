class CashAccountLogPresenter < BasePresenter
	presents :log
	delegate_missing_to :log

	def codigo
		link_to log.codigo, expense_path(log.logable_id)
	end

	def action_links
		
	end
end