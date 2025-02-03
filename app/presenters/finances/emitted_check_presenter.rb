class EmittedCheckPresenter < BasePresenter
  presents :emitted_check
  delegate :vencimiento, to: :emitted_check

  def numero
    link_to emitted_check.numero, emitted_check_path(emitted_check)
  end

  def estado
    case emitted_check.estado
    when "Pagado"
      handle_state("success", emitted_check.estado)
    when "Anulado"
      handle_state("dark", emitted_check.estado)
    when "Pendiente"
      handle_state("warning", emitted_check.estado)
    end
  end

  def chequera
    emitted_check.checkbook.try(:number)
  end

  def banco
    emitted_check.bank_account.try(:bank).try(:name) || emitted_check.checkbook.try(:bank_account).try(:bank).try(:name)
  end

  def proveedor
    link_to emitted_check.supplier.name, supplier_path(emitted_check.supplier)
  end

  def importe_pagado
    content_tag :div, class: "text-right" do
      number_to_ars emitted_check.importe_pagado
    end
  end

  def saldo
    content_tag :div, class: "text-right" do
      number_to_ars emitted_check.saldo
    end
  end

  def importe
    content_tag :div, class: "text-right" do
      number_to_ars emitted_check.importe
    end
  end

  def orden_pago
    unless emitted_check.payment_order.nil?
      link_to emitted_check.payment_order.name, purchases_payment_order_path(emitted_check.payment_order)
    end
  end

  def action_links
    # code
  end
end
