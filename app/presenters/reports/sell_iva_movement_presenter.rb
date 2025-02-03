class Reports::SellIvaMovementPresenter < BasePresenter
  presents :buy_iva_movement

  def number
    path = case buy_iva_movement.try(:type)
    when "Sales::Bill"
      edit_sales_bill_path(buy_iva_movement)
    when "Tenders::Bill"
      edit_tenders_bill_path(buy_iva_movement)
    when "Surgeries::ClientBill"
      edit_surgeries_client_bill_path(buy_iva_movement)
    end
    link_to buy_iva_movement.number, path
  end

  def full_name
    buy_iva_movement.full_name
  end

  def emision
    Date.strptime(buy_iva_movement.authorized_on, "%Y%m%d%H%M%S") unless buy_iva_movement.authorized_on.nil?
  end

  def cbte_tipo
    path = case buy_iva_movement.try(:type)
    when "Sales::Bill"
      edit_sales_bill_path(buy_iva_movement)
    when "Tenders::Bill"
      edit_tenders_bill_path(buy_iva_movement)
    when "Surgeries::ClientBill"
      edit_surgeries_client_bill_path(buy_iva_movement)
    end
    link_to buy_iva_movement.cbte_short_name, path
  end

  def zone
		buy_iva_movement.dig(:client, :province, :name)
	end

  def pto_venta
    buy_iva_movement.try(:sale_point)
  end

  def date
    buy_iva_movement.date
  end

  def entity
    "#{buy_iva_movement.entity.try(:name)}"
  end

  def cuit
    "#{buy_iva_movement.entity.try(:document_number)}"
  end

  def ex_amount
    if buy_iva_movement.is?(:credit_note)
      -buy_iva_movement.imp_op_ex
    else
      buy_iva_movement.imp_op_ex
    end
  end

  def net_amount
    if buy_iva_movement.is?(:credit_note)
      -buy_iva_movement.imp_neto
    else
      buy_iva_movement.imp_neto
    end
  end

  def iva_21_amount
    if buy_iva_movement.is?(:credit_note)
      - buy_iva_movement.details.where(iva_aliquot: "05").sum(:iva_amount).round(2)
    else
      buy_iva_movement.details.where(iva_aliquot: "05").sum(:iva_amount).round(2)
    end
  end

  def iva_105_amount
    if buy_iva_movement.is?(:credit_note)
      - buy_iva_movement.details.where(iva_aliquot: "04").sum(:iva_amount).round(2)
    else
      buy_iva_movement.details.where(iva_aliquot: "04").sum(:iva_amount).round(2)
    end
  end

  def iva_aliquot
    aliquot = buy_iva_movement.details.first.try(:iva_aliquot) || "05"
    data = Afip::ALIC_IVA.map { |a| a.last if a.first == aliquot }.compact.first
    return "% #{data.to_f * 100}"
  end

  def perc_ib
    buy_iva_movement.tributes.where(afip_id: "7").sum(:amount).round(2)
  end

  def total
    if buy_iva_movement.is?(:credit_note)
      -buy_iva_movement.total
    else
      buy_iva_movement.total
    end
  end

  def action_links
	end
end
