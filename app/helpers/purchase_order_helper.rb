module PurchaseOrderHelper
	def new_purchase_oder_consumption builder, str, es
		@f = builder
		html_2= <<-HTML
			<div class="row">
				<div class="col-2">
					#{button_to_add_consumption(es)}
				</div>
				<div class="col-10 d-flex flex-wrap" id="fieldset_consumption">
					#{builder.simple_fields_for(:surgery_order_consumptions, wrapper: false) {|p| concat(associated_consumptions(p))}}
				</div>
			</div>
		HTML
		return html_2.html_safe
	end

	def associated_consumptions t
		association = t.association :surgery_consumption, as: :select, label: false, value_method: :id, label_method: :number, input_html: {data: {url: index_by_file_surgery_consumptions_path, extra_data: "#file_select"}}
		html_2 = <<-HTML
			<div class="fields">
				<div class='px-2 d-flex small-form'>
					#{association}
					<div class='input-group-append mb-3'>
						#{t.link_to_remove icon('fas', 'trash'), class: "btn btn-danger btn-sm #{'disabled' if @f.object.disabled?}"}
					</div>
				</div>
			</div>
		HTML
		return html_2.html_safe
	end

  def button_to_add_consumption es
    if @f.object.purchase_file_id.blank? && params[:purchase_file_id].blank?
      content_tag :span, class: 'd-inline-block', tabindex: 0, data: {toggle: 'tooltip', placement: "right"}, title: "Primero debe seleccionar el expediente" do
        @f.link_to_add "#{icon('fas', 'plus')} Asociar #{es}".html_safe, :surgery_order_consumptions, class: "btn btn-sm btn-success align-self-start disabled new_associated_document", data: {target: '#fieldset_consumption'}
      end
    else
      content_tag :span, class: 'd-inline-block', tabindex: 0, data: {toggle: 'tooltip', placement: "right", "original-title" => "Primero debe seleccionar el expediente"}, title: "" do
        @f.link_to_add "#{icon('fas', 'plus')} Asociar remito".html_safe, :surgery_order_consumptions, class: "btn btn-sm btn-success align-self-start new_associated_document #{'disabled' if @f.object.disabled?}", data: {target: '#fieldset_consumption'}
      end
    end
  end
end
