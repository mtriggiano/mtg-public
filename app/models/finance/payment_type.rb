class PaymentType < ApplicationRecord
	belongs_to :cash_account, optional: true

	COLLECT_TYPES = ['Efectivo ($)', 'Efectivo (U$S)', 'Efectivo (EUR)', 'Cheque', 'Pagaré', 'Tarjeta de crédito', 'Tarjeta de débito', 'Transferencia bancaria', 'Cheque electrónico', 'Compensación']

	validates_presence_of :name, messgae: "Debe especificar el nombre"
	validates :collect_type,
		presence: { message: "Seleccione el tipo de pago." },
		inclusion: { in: COLLECT_TYPES, message: "El tipo de pago seleccionado es incorrecto." }
	validate :cash_account_reference

	scope :sin_caja, -> { where(cash_account: nil) }
	scope :vista_en_caja, -> { where(collect_type: ['Efectivo ($)', 'Efectivo (U$S)', 'Tarjeta de crédito', 'Tarjeta de débito', 'Transferencia bancaria']) }
	scope :efectivo_pesos, -> { where(collect_type: 'Efectivo ($)') }
	scope :efectivo_dolares, -> { where(collect_type: 'Efectivo (U$S)') }
	scope :tarjetas_credito, -> { where(collect_type: 'Tarjeta de crédito') }
	scope :tarjetas_debito, -> { where(collect_type: 'Tarjeta de débito') }
	scope :transferencias, -> { where(collect_type: 'Transferencia bancaria') }

	def promesa_de_pago?
	  cheque? || pagare?
	end

	def self.search data
		all
	end

	def cheque?
	  collect_type == "Cheque"
	end

	def pagare?
	  collect_type == "Pagaré"
	end

	def transferencia?
	  collect_type == "Transferencia bancaria"
	end

	def reinicia_balance!
	  update_columns(balance: 0)
	end

	def upcase_name
	  name.upcase
	end

	private

	def cash_account_reference
	  errors.add(:base, "Debe seleccionar una caja donde se imputarán los gastos.") if self.imputed_in_cash && self.cash_account_id.nil?
	end
end
