class Reports::CostingPresenter < BasePresenter
	presents :file
	delegate_missing_to :file

  def title
    link_to file.title, costing_reports_purchase_path(file.id), class: 'border-animated font-weight-bold', data: {"skip-pjax" => true}
  end

  def surgery_end_date
    handle_date(file.surgery_end_date)
  end

  def doctor
    handle_none(file.doctor)
  end

  def patient
    handle_none(file.pacient)
  end

  def entity
    link_to file.client.try(:name), file.client
  end

  def sale_orders_total
    sale_orders.sum(:total).round(2)
  end

  def state
		case file.state
		when "ENTREGADO"
			color = 'success'
		when "PENDIENTE DE STICKER"
			color = 'info'
		when "PENDIENTE DE O.C"
			color = 'info'
		when "PENDIENTE DE DOCUMENTACION CLÍNICA"
			color = 'info'
		when "COORDINAR FECHA DE CX"
			color = 'primary'
		when "LISTO PARA ENTREGA"
			color = 'primary'
		when "PERDIDO"
			color = 'danger'
		when "CANCELADO"
			color = 'dark'
		when nil
			color = 'secondary'
		else
			color = 'info'
		end
		super(color, "#{file.state} - #{file.substate}")
	end

  def margin
    if file.margin < 0
      handle_state('danger', "$#{file.margin}")
    elsif file.margin == 0
      handle_state('warning', "$#{file.margin}")
    else
      handle_state('success', "$#{file.margin}")
    end
  end

  def suppliers
    file.suppliers.map(&:name).join(", ")
  end

  def action_links; end

	def earned_product_amount
			content_tag :div, "$ #{product_gain}" ,class: 'font-weight-bold text-success'
	end

	def expended_product_amount
		content_tag :div, "$ #{product_costing}" ,class: 'font-weight-bold text-danger'
	end

	def earned_service_amount
			content_tag :div, "$ #{service_gain}" ,class: 'font-weight-bold text-success'
	end

	def expended_service_amount
		content_tag :div, "$ #{service_costing}" ,class: 'font-weight-bold text-danger'
	end

	def fee
		"Pendiente"
	end

	def shipment_cost
		content_tag :div, "$ #{file.sale_orders.sum(:shipping_price).to_f.round(2).to_s}", class: 'font-weight-bold text-danger'
	end

	def logistics
		"Pendiente"
	end

	def cash_account_expenditures
		content_tag :div, "$ #{cash_account_expenditures_costing}", class: 'font-weight-bold text-danger'
	end

	def total_expenditures
		total = product_costing + service_costing + shipment_costing + cash_account_expenditures_costing
		content_tag :div, "$ #{total}", class: 'font-weight-bold text-danger'
	end

	def total_earned
		total = client_bills.sum(:total)
		content_tag :div, "$ #{total}", class: 'font-weight-bold text-success'
	end

end
