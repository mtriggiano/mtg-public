module Purchases::PurchaseInvoicesHelper

	def purchase_arrival_select builder 
    	if purchase_invoice.new_record? && params[:purchase_file_id].blank?
  			content_tag :span, class: 'd-inline-block', tabindex: 0, data: {toggle: 'tooltip', placement: "right"}, title: "Primero debe seleccionar el expediente" do
  				concat(builder.association :purchase_arrival, wrapper_html: {class: 'd-flex'}, label_html: {class: 'pr-2'},label_method: :number, label: "Remito", as: :select, include_blank: true, input_html: {class: 'new_associated_document', data: {placeholder: "Remito", url: index_by_file_purchase_arrivals_path, extra_data: "#file_select"}, id: "new_associated_document"}, selected: params[:purchase_arrival_id], disabled: (purchase_invoice.purchase_file_id.blank? && !params[:purchase_file_id]) || purchase_invoice.disabled?)
  			end
    	else
      	 	content_tag :span, class: 'd-inline-block', tabindex: 0, data: {toggle: 'tooltip', placement: "right", "original-title" => "Primero debe seleccionar el expediente"}, title: "" do
      	 		concat(builder.association :purchase_arrival, wrapper_html: {class: 'd-flex'}, label_html: {class: 'pr-2'},label_method: :number, label: "Remito", as: :select, include_blank: true, input_html: {class: 'new_associated_document', data: {placeholder: "Remito", url: index_by_file_purchase_arrivals_path, extra_data: "#file_select"}, id: "new_associated_document"}, disabled: (purchase_invoice.purchase_file_id.blank? && !params[:purchase_file_id]) || purchase_invoice.disabled?)
      	 	end
   		end
	end

end