class Reports::ExpedientPresenter < SaleApplicationPresenter
	presents :file
	delegate_missing_to :file

	def number
		unless file.number.nil?
			link_to file.number, polymorphic_url(file), class: 'border-animated font-weight-bold'
		else
			"Sin especificar"
		end
	end

  def sellers
    result = []
    file.expedient_orders.each do |eo|
      eo.sellers.each do |seller|
        result << link_to(seller.name, seller)
      end
    end
    result.join(", ").html_safe
  end

	def state
	  file.state
	end

  def sale_orders_total
		orders = file.expedient_orders
      .approveds
      .billed
      .select{|eo| ["Surgeries::SaleOrder", "Sales::Order", "Tenders::Order"].include?(eo.type)}
		if orders.any?
			"$ " +  orders.inject(0){|sum, eo| sum += eo.total}.round(2).to_s
		else
			"-"
		end
  end

  def entity
    link_to file.entity.try(:name), file.entity if file.entity
  end

  def products_family
    result = nil
    file.expedient_shipments.each do |es|
      es.details.each do |detail|
        result = detail.inventary.try(:family) unless detail.inventary.try(:family).nil?
      end
    end
    result
  end

  def institution
    file.place
  end

  def shipments
    file.expedient_shipments.map do |shipment|
      link_to shipment.number, [:edit, shipment]
    end.join(", ").html_safe
  end

  def shipments_dates
    expedient_shipments.map{|s| s.date}.join(", ")
  end

  def mora
    # expedient_shipments.approveds.each do |shipment|
    #   shipment.expedient_bills.each do |bill|
    # end
		if file.type == "Surgeries::File"
			if file.client_bills.blank?
				date = file.shipments.approveds.order("shipments.date asc").last.try(:date) || file.finish_date
				return days_calc = (Date.today - date).to_i
			else
				"FACTURADO"
			end
		else
			if file.bills.blank?
				date = file.shipments.approveds.order("shipments.date asc").last.try(:date) || file.finish_date
				return days_calc = (Date.today - date).to_i
			else
				"FACTURADO"
			end
		end
  end

	def title
		link_to file.title, file
	end

	def have_implant_certificate
		if file.need_implant
			if file.implant_certificate.blank? || file.implant_certificate == "/images/attachment.png"
				content_tag(:div, icon('fas', 'times'), class: 'text-danger')
			else
				if file.implant_state == "success"
					content_tag(:div, icon('fas', 'check-double'), class: 'text-success')
				elsif file.implant_state == "danger"
					content_tag(:div, icon('fas', 'user-times'), class: 'text-danger')
				else
					content_tag(:div, icon('fas', 'check'), class: 'text-secondary')
				end
			end
		else
			content_tag(:div, icon('fas', 'minus'), class: 'text-secondary')
		end
	end

	def have_surgical_sheet
		if file.need_surgical_sheet
			if file.surgical_sheet.blank? || file.surgical_sheet == "/images/attachment.png"
				content_tag(:div, icon('fas', 'times'), class: 'text-danger')
			else
				if file.surgical_sheet_state == "success"
					content_tag(:div, icon('fas', 'check-double'), class: 'text-success')
				elsif file.surgical_sheet_state == "danger"
					content_tag(:div, icon('fas', 'user-times'), class: 'text-danger')
				else
					content_tag(:div, icon('fas', 'check'), class: 'text-secondary')
				end
			end
		else
			content_tag(:div, icon('fas', 'minus'), class: 'text-secondary')
		end
	end

	def have_note
		if file.need_note
			if file.note.blank? || file.note == "/images/attachment.png"
				content_tag(:div, icon('fas', 'times'), class: 'text-danger')
			else
				content_tag(:div, icon('fas', 'check'), class: 'text-success')
			end
		else
			content_tag(:div, icon('fas', 'minus'), class: 'text-secondary')
		end
	end

	def have_sticker

		if file.need_sticker
			if file.sticker.blank? || file.sticker == "/images/attachment.png"
				content_tag(:div, icon('fas', 'times'), class: 'text-danger')
			else
				content_tag(:div, icon('fas', 'check'), class: 'text-success')
			end
		else
			content_tag(:div, icon('fas', 'minus'), class: 'text-secondary')
		end
	end

	def have_sale_order_attachements
		band = false
		file.expedient_orders.select{|eo| ["Surgeries::SaleOrder", "Sales::Order", "Tenders::Order"].include? eo.type}.each do |orders|
			orders.attachments.each do |a|
				band = true
			end
		end
		if band
			content_tag(:div, icon('fas', 'check'), class: 'text-success')
		else
			content_tag(:div, icon('fas', 'times'), class: 'text-danger')
		end
	end

	def have_partial_delivery
		band = file.substate == "ENTREGA PARCIAL"
		if band
			content_tag(:div, icon('fas', 'check'), class: 'text-success')
		else
			content_tag(:div, icon('fas', 'times'), class: 'text-danger')
		end
	end

	def have_full_delivery
		band = (file.substate == "ENTREGADO" || file.substate == "ENTREGA TOTAL")
		if band
			content_tag(:div, icon('fas', 'check'), class: 'text-success')
		else
			content_tag(:div, icon('fas', 'times'), class: 'text-danger')
		end
	end

  def action_links

  end
end
