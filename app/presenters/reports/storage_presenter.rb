class Reports::StoragePresenter < BasePresenter
	presents :storage
	delegate_missing_to :storage

	def entity
		link_to storage.client.try(:name), storage.client
	end

	def number
		link_to storage.number, edit_polymorphic_url(storage)
	end

	def pacient
		storage.file.try(:pacient)
	end

	def sale_order
		storage.orders.pluck(:number).join(", ")
	end

	def file
		link_to storage.file.try(:title), storage.file  if storage.file
	end

	def external_file_number
		storage.file.try(:external_number)
	end

	def sale_type
		storage.file.try(:sale_type)
	end

	def  bill
		storage.expedient_bills.map(&:full_name).join(", ")
	end

	def consumption
		storage.consumptions.map(&:number).join(", ")
	end

	def external_purchase_order
		storage.file.try(:external_purchase_order_number)
	end

	def user
		storage.user.name
	end

	def location
		storage.location.try(:address)
	end

	def state
		case storage.state
		when "Confirmado"
			span = 'success'
		when "Anulado"
			span = 'danger'
		end
		super(span, storage.state)
	end

	def conformed
	  storage.conformed ? "SI" : "NO"
	end

	def importe
	  number_to_ars(storage.orders.sum(:total))
	end

	def surgery_date
	  storage.file.try(:surgery_end_date)
	end

	def date
	  storage.date
	end

	def days_sin_facturar
		if storage.expedient_bills.blank?
	  	"#{(Date.today - storage.date).to_i} días"
		else
			"Facturado"
		end
	end

	def seller
		details = ExpedientOrderDetail.where(order_id: storage.orders.ids).where.not(user_id: nil)
		if details.blank?
			return ""
		else
	  	return details.map{|d| d.seller.try(:name)}.uniq.compact.join(", ")
		end
	end

	def action_links

	end
end
