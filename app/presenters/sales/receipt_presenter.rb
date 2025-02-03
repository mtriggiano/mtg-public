class Sales::ReceiptPresenter < SaleApplicationPresenter
  	presents :receipt

	def state
		case receipt.state
		when "Pendiente"
			span = 'warning'
		when "Finalizado"
			span = 'success'
		when "Anulado"
			span = 'dark'
		end
		super(span, receipt.state)
	end

	def banks
		receipt.bank_accounts.map(&:alias_tag).join(", ")
	end

	def payment_types
		receipt.payment_types.map(&:name).join(", ")
	end
end
