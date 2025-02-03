class ExpenditurePresenter < BasePresenter
  presents :expenditure
  delegate :descripcion, to: :expenditure
  delegate :fecha, to: :expenditure
  delegate :fecha_registro, to: :expenditure

  def action_links
    content_tag :div, class: "text-center" do
      concat(link_to_edit edit_expenditure_path(expenditure.id), {id: "edit_expenditure", data:{target: "#edit_expenditure_modal", toggle: "modal", form: true}})
      concat(link_to_destroy expenditure_path(expenditure.id) )
    end
  end

  def proveedor
    "#{expenditure.supplier_name} - #{expenditure.supplier.try(:full_document)}"
  end

  def comprobante
    expenditure.codigo_comprobante
  end

  def importe_neto
    content_tag :div, class: "text-right" do
      number_to_ars expenditure.total
    end
  end
end
