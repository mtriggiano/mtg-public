class Reports::BillPresenter < BasePresenter
	presents :bill
	delegate_missing_to :bill

	def zone
		bill.dig(:entity, :province, :name)
	end

	def pacient
		bill.dig(:file, :pacient)
	end

	def credit
		bill.associated_documents.map do |assoc|
			link_to -assoc.total, [:edit, assoc] if assoc.is?(:credit_note)
		end.join(", ").html_safe
	end

	def mora
		if bill.real_total_left != 0
			((bill.receipts.order(date: :asc).last.try(:date) || bill.date) - Date.today).to_i
		end
	end

	def day
		bill.date.day
	end

	def month
		bill.date.month
	end

	def year
		bill.date.year
	end

	def debit
		bill.associated_documents.map do |assoc|
			link_to assoc.total, [:edit, assoc] if assoc.is?(:debit_note)
		end.join(", ").html_safe
	end

	def cbte_tipo
		case bill.type
		when "Sales::Bill"
			unless bill.file.nil? || bill.entity.nil?
				link_to bill.cbte_short_name, edit_sales_bill_path(bill)
			else
				bill.cbte_short_name
			end
		when "Tenders::Bill"
			unless bill.file.nil? || bill.entity.nil?
				link_to bill.cbte_short_name, edit_tenders_bill_path(bill)
			else
				bill.cbte_short_name
			end
		when "Surgeries::ClientBill"
			unless bill.file.nil? || bill.entity.nil?
				link_to bill.cbte_short_name, edit_surgeries_client_bill_path(bill)
			else
				bill.cbte_short_name
			end
		end
  end

  	def emision
    	Date.strptime(bill.authorized_on, "%Y%m%d%H%M%S") unless bill.authorized_on.nil?
  	end

	def number
		# link_to bill.full_name, polymorphic_path([:edit, bill])

		case bill.type
		when "Sales::Bill"
			unless bill.file.nil? || bill.entity.nil?
				link_to bill.number, edit_sales_bill_path(bill)
			else
				bill.number
			end
		when "Tenders::Bill"
			unless bill.file.nil? || bill.entity.nil?
				link_to bill.number, edit_tenders_bill_path(bill)
			else
				bill.number
			end
		when "Surgeries::ClientBill"
			unless bill.file.nil? || bill.entity.nil?
				link_to bill.number, edit_surgeries_client_bill_path(bill)
			else
				bill.number
			end
		end
	end

	def sale_point
		bill.sale_point.rjust(4, '0') unless bill.sale_point.nil?
	end

	def total
		bill.is?(:credit_note) ? -bill.total : bill.total
	end

	def total_pay
		bill.total_pay
	end

	def total_left
		bill.real_total_left
	end

	def usd_price
		handle_currency(bill.usd_price, "$")
	end

	def total_usd
		handle_currency( (bill.total / bill.usd_price).round(2), "$")
	end

	def external_purchase_order
		bill.dig(:file, :external_purchase_order_number)
	end

	def seller
		bill.sellers.map do |seller|
			link_to seller.name, seller
		end.join(", ").html_safe
	end

	def cancelation
		bill.cancelation_date
	end


	def client
		unless bill.entity.nil?
			entity_name = bill.entity.try(:denomination) || bill.entity.try(:name)
			link_to entity_name, polymorphic_path(bill.entity)
		else
			"Sin especificar"
		end

	end

	def external_number
		bill.file.try(:external_number) if bill.file
	end

	def state
		case bill.state
		when "Confirmado"
			span = 'success'
		when "Anulado"
			span = 'danger'
		end
		super(span, bill.state)
	end

	def action_links

	end

	def payment_type
		bill.payment_type.try(:name)
	end

	def sale_type
		bill.file.try(:sale_type) if bill.file
	end

	def fch_vto_pago
		bill.fch_vto_pago || "Sin especificar"
	end

	def due_date
	  # unless bill.date.blank?
		# 	dudate = bill.date.to_date + 30.days
		# 	"#{-(Date.today - (dudate)).to_i} días (#{dudate})"
		# else
		# 	"Sin especificar"
		# end
	end
end
