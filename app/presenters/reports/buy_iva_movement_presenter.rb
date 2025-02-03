class Reports::BuyIvaMovementPresenter < BasePresenter

  presents :buy_iva_movement

  #delegate :gross_amount, to: :buy_iva_movement
  delegate :iva_amount, to: :buy_iva_movement

  #@tributes = buy_iva_movement.tributes

  def number
    buy_iva_movement.number
  end

  def cbte_tipo
    buy_iva_movement.cbte_short_name
  end

  def zone
		buy_iva_movement.dig(:client, :province, :name)
	end

  def pto_venta
    buy_iva_movement.try(:sale_point)
  end

  def date
    if buy_iva_movement.type == "ExternalBill"
      buy_iva_movement.cbte_fch
    else
      buy_iva_movement.cbte_fch
    end
  end

  def registration_date
    buy_iva_movement.registration_date
  end

  def entity
    "#{buy_iva_movement.entity.try(:name)}"
  end

  def cuit
    "#{buy_iva_movement.entity.try(:document_number)}"
  end

  def net_amount
    if buy_iva_movement.type != "ExternalBill"
      exp_detail = buy_iva_movement.becomes!(buy_iva_movement.type.constantize)#.find(buy_iva_movement.id)
      number_to_ars((exp_detail.total.to_f.round(2) - exp_detail.iva_amount.to_f.round(2) - exp_detail.imp_tot_conc.to_f.round(2) - exp_detail.percep_iva.to_f.round(2) - exp_detail.percep_iibb.to_f.round(2)).round(2))
    else
      total = buy_iva_movement.gross_amount - buy_iva_movement.details.select{|d| ["02", "01"].include?(d.iva_aliquot)}.inject(0){|sum, det| sum += det.neto}
      if buy_iva_movement.is?(:credit_note)
        number_to_ars(-total)
      else
        number_to_ars(total)
      end
    end

  end

  def exento
    if buy_iva_movement.type != "ExternalBill"
      number_to_ars(buy_iva_movement.becomes!(buy_iva_movement.type.constantize).exento.to_f.round(2))
    else
      if buy_iva_movement.is?(:credit_note)
        number_to_ars(-buy_iva_movement.details.select{|d| d.iva_aliquot == "02"}.inject(0){|sum, det| sum += det.neto})
      else
        number_to_ars(buy_iva_movement.details.select{|d| d.iva_aliquot == "02"}.inject(0){|sum, det| sum += det.neto})
      end
    end
  end

  def no_grav
    if buy_iva_movement.type != "ExternalBill"
      number_to_ars(buy_iva_movement.becomes!(buy_iva_movement.type.constantize).imp_tot_conc.to_f.round(2))
    else
      if buy_iva_movement.is?(:credit_note)
        number_to_ars(-buy_iva_movement.details.select{|d| d.iva_aliquot == "01"}.inject(0){|sum, det| sum += det.neto})
      else
        number_to_ars(buy_iva_movement.details.select{|d| d.iva_aliquot == "01"}.inject(0){|sum, det| sum += det.neto})
      end
    end
  end

  def iva_amount
    if buy_iva_movement.type != "ExternalBill"
      number_to_ars(buy_iva_movement.becomes!(buy_iva_movement.type.constantize).iva_amount.to_f.round(2))
    else
      if buy_iva_movement.is?(:credit_note)
        number_to_ars(-buy_iva_movement.iva_amount)
      else
        number_to_ars(buy_iva_movement.iva_amount)
      end
    end
  end

  def per_ib_sla
    tribute_handler("Percepción de IIBB Salta")
  end

  def per_ib_juy
    tribute_handler("Percepción de IIBB Jujuy")
  end

  def per_ib_cat
    tribute_handler("Percepción de IIBB Catamarca")
  end

  def ret_ib
    tribute_handler("Retención de IIBB")
  end

  def ret_gcias
    tribute_handler("Retención de Ganancias")
  end

  def ret_ganancias
    tribute_handler("Retención de Ganancias")
  end

  def per_iva
    if buy_iva_movement.type != "ExternalBill"
      number_to_ars(buy_iva_movement.becomes!(buy_iva_movement.type.constantize).percep_iva.to_f.round(2))
    else
      tribute_handler("Percepción de IVA")
    end
  end

  def imp_nac
    tribute_handler("Impuestos nacionales")
  end

  def imp_prov
    tribute_handler("Impuestos provinciales")
  end

  def imp_mun
    tribute_handler("Impuestos municipales")
  end

  def imp_int
    tribute_handler("Impuestos Internos")
  end

  def iibb
    tribute_handler("IIBB")
  end

  def per_iibb
    if buy_iva_movement.type != "ExternalBill"
      number_to_ars(buy_iva_movement.becomes!(buy_iva_movement.type.constantize).percep_iibb.to_f.round(2))
    else
      tribute_handler("Percepción de IIBB")
    end
  end

  def per_imp_mun
    tribute_handler("Percepciones por Impuestos Municipales")
  end

  def otras_per
    tribute_handler("Otras Percepciones")
  end

  def per_iva_no_cat
    tribute_handler("Percepción de IVA a no Categorizado")
  end


  def iva_aliquot
    aliquot = buy_iva_movement.details.first.try(:iva_aliquot) || "05"
    data = Afip::ALIC_IVA.map { |a| a.last if a.first == aliquot }.compact.first
    return "% #{data.to_f * 100}"
  end

  def total
    if buy_iva_movement.is?(:credit_note)
      number_to_ars(-buy_iva_movement.total)
    else
      number_to_ars(buy_iva_movement.total)
    end
  end



  def tribute_handler(description)
    return number_to_ars(0) if buy_iva_movement.type != "ExternalBill"
    if buy_iva_movement.is?(:credit_note)
      number_to_ars(-buy_iva_movement.tributes.select{|t| t.description == description}.inject(0){|sum, trib| sum += trib.amount})
    else
      number_to_ars(buy_iva_movement.tributes.select{|t| t.description == description}.inject(0){|sum, trib| sum += trib.amount})
    end
  end

  def action_links

	end

end
