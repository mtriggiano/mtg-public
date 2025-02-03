class PromissoryPaymentPresenter < BasePresenter
	presents :promissory_payment
	delegate_missing_to :promissory_payment

	def number
		link_to promissory_payment.numero_cheque, promissory_payment_path(promissory_payment)
	end

	def numero_cheque
		link_to promissory_payment.numero_cheque, promissory_payment_path(promissory_payment)
	end

	def receipt
		link_to "X-#{promissory_payment.receipt.number}", edit_expedient_receipt_path(promissory_payment.receipt) if promissory_payment.receipt
	end

	def client
		promissory_payment.client.try(:name)
	end

	def dias
		promissory_payment.dias_restantes(Date.today)
	end
end
