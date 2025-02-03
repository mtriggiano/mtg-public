module PdfCurrency
	extend ActiveSupport::Concern

  def currency_label
    currency == "ARS" ? "pesos" : "dólares"
  end

  def total_pdf
    currency == "ARS" ? total : (total / usd_price).to_f.round(2)
  end

  def iva_amount_pdf
		if ["Surgeries::Budget", "Sales::Budget", "Tenders::Budget"].include?(self.class.name)
			iva_amount = details.where(base_offer: true).map{|det| det.iva_amount}.inject(0,:+)
		else
			iva_amount = details.map{|detail| detail.iva_amount }.inject(0,:+)
		end
		return currency == "ARS" ? iva_amount : (iva_amount / usd_price).to_f.round(2)
  end

  def subtotal_pdf
    currency == "ARS" ? subtotal : (subtotal / usd_price).to_f.round(2)
  end

  def discount_pdf
    currency == "ARS" ? discount : (discount / usd_price).to_f.round(2)
  end
end
