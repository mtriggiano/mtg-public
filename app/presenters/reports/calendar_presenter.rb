class Reports::CalendarPresenter < BasePresenter
	presents :file
	delegate_missing_to :file

  def delivery_date
    result = []
    file.expedient_budgets.each do |b|
      if b.delivery_date
        result << link_to(b.delivery_date, [:edit, b])
      end
    end
    result.join(", ").html_safe
  end

  def sale_orders
    file.expedient_orders.map(&:number).join(", ")
  end

  def observation
    file.expedient_budgets.map(&:observation).join(".")
  end

  def title
    link_to file.title, file
  end

  def client
    file.entity.name
  end

  def user
    file.user.try(:name)
  end

  def shipments
    file.expedient_shipments.map{ |s| link_to s.number, [:edit, s]}.join(", ").html_safe
  end

  def surgical_sheet
    file.surgical_sheet_original_filename
  end

  def implant_certificate
    file.implant_original_filename
  end

	def client
		if file.entity
			link_to file.entity.name, file.entity
		else
			"Cliente eliminado"
		end
	end

	def surgical_sheet
		link_to file.surgical_sheet_original_filename, file.surgical_sheet, target: '_blank', data: {'skip-pjax' => true} if file.surgical_sheet
	end

	def implant_certificate
		link_to file.implant_original_filename, file.implant_certificate, target: '_blank', data: {'skip-pjax' => true} if file.implant_certificate
	end

	def state
		case file.state
		when "Finalizado"
			span = 'success'
		when "En espera de presupuesto"
			span = 'warning'
		when "En espera de orden de compra"
			span = 'warning'
		when "En espera de facturación"
			span = 'warning'
		else
			span = 'info'
		end
		html = <<-HTML
		<span class='badge-#{span} rounded p-2 small'>#{file.state}</span>
		HTML
		return html.html_safe
	end

  def action_links

  end
end
