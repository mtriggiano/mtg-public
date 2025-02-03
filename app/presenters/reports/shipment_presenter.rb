class Reports::ShipmentPresenter < BasePresenter
	presents :shipment
	delegate_missing_to :shipment

    
	def entity
		link_to shipment.client.try(:name), shipment.client
	end

	def number
		link_to shipment.number, edit_polymorphic_url(shipment)
	end

	def pacient
		shipment.file.try(:pacient)
	end

	def sale_order
		shipment.file.expedient_orders.pluck(:number).join(", ") rescue nil
	end

	def file
		link_to shipment.file.try(:title), shipment.file  if shipment.file
	end

	def external_file_number
		shipment.file.try(:external_number)
	end

	def sale_type
		shipment.file.try(:sale_type)
	end

	def  bill
		shipment.expedient_bills.map{ |bill| link_to bill.full_name, bill }.join(", ").html_safe
	end

	def consumption
		shipment.consumptions.map(&:number).join(", ")
	end

	def external_purchase_order
		shipment.file.try(:external_purchase_order_number)
	end

	def user
		shipment.user.name
	end

	def location
		shipment.location.try(:address)
	end

	def state
		case shipment.state
		when "Confirmado"
			span = 'success'
		when "Anulado"
			span = 'danger'
		end
		super(span, shipment.state)
	end

	def conformed
	  shipment.conformed ? "SI" : "NO"
	end

	def importe
	  number_to_ars(shipment.file.expedient_orders.map{|order| order.total}.sum) rescue nil
	end

	def surgery_date
	  shipment.file.try(:surgery_end_date)
	end

	def date
	  shipment.date
	end

	def days_sin_facturar
		if shipment.expedient_bills.blank?
	  	"#{(Date.today - shipment.date).to_i} días"
		else
			"Facturado"
		end
	end

	def seller
        details = shipment.file
            .expedient_orders
            .map{|order| order.all_details }
            .flatten
            .uniq 
            .map{|detail| detail.seller.try(:name)}
            .uniq
            .compact
            .join(", ") rescue []
    end

	def substate
	  shipment.file.substate rescue nil
	end

	def action_links

	end
end
