class Reports::ConsumptionPresenter < BasePresenter
	presents :consumption
	delegate_missing_to :consumption

	def surgery_date
		consumption.file.try(:surgery_end_date)
	end

	def sale_orders
		consumption.sale_orders.map do |so|
			link_to so.number, [:edit, so]
		end.join(", ").html_safe
	end

	def pacient
		consumption.file.try(:pacient)
	end

	def doctor
		consumption.file.try(:doctor)
	end

	def user
		consumption.user.try(:name)
	end

	def purchase_orders
		consumption.purchase_orders.map do |po|
			link_to po.number, [:edit, po]
		end.join(", ").html_safe
	end

	def action_links
    link_to_pdf surgeries_consumption_path(consumption, {format: :pdf})
  end

	def shipments
		consumption.shipments.map do |eo|
      link_to(eo.number, [:edit, eo])
    end.join(", ").html_safe
	end

	def file
		consumption.file.try(:title)
	end

	def client
		consumption.client.try(:denomination)
	end
end
