class ImprestClearingPresenter < BasePresenter
	presents :imprest_clearing
	delegate_missing_to :imprest_clearing

	def id
		link_to imprest_clearing.id.to_s.rjust(8, '0'), analyze_regular_cash_account_imprest_clearing_path(imprest_clearing.regular_cash_account, imprest_clearing)
	end

	def regular_cash_account
		imprest_clearing.regular_cash_account.nombre
	end

	def user
		imprest_clearing.user.name
	end

	def fondo_fijo
		number_to_ars imprest_clearing.fondo_fijo
	end

	def saldo_inicio
		number_to_ars imprest_clearing.saldo_inicio
	end

	def a_rendir
		number_to_ars imprest_clearing.a_rendir
	end

	def saldo_en_caja
		number_to_ars imprest_clearing.saldo_en_caja
	end

	def action_links
		link_to_pdf regular_cash_account_imprest_clearing_path(imprest_clearing.regular_cash_account, imprest_clearing, format: :pdf) if imprest_clearing.confirmado?
	end
end