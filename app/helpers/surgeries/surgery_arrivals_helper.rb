module Surgeries::SurgeryArrivalsHelper

	def new_associated_arrival_document builder
		@builder = builder
		html = <<-HTML
			<div class="row">
				<div class="col-2">
					#{button_to_add_associated_arrival_request}
				</div>
				<div class="col-10 d-flex flex-wrap" id="fieldset">
					#{builder.simple_fields_for(:surgery_arrival_requests, wrapper: false) {|p| concat(associated_arrival_requests_fields(p))}}
				</div>
			</div>
		HTML
		return html.html_safe
	end

	def associated_arrival_requests_fields p
		association = p.association :surgery_request, as: :select, label: false, value_method: :id, label_method: :number, input_html: {data: {url: index_by_file_surgery_requests_path, extra_data: "#file_select"}}
		html = <<-HTML
			<div class="fields">
				<div class='px-2 d-flex small-form'>
					#{association}
					<div class='input-group-append mb-3'>
						#{p.link_to_remove icon('fas', 'trash'), class: "btn btn-danger btn-sm #{'disabled' if @builder.object.disabled?}"}
					</div>
				</div>
			</div>
		HTML
		return html.html_safe
	end

  def button_to_add_associated_arrival_request
    if @builder.object.purchase_file_id.blank? && params[:purchase_file_id].blank?
      content_tag :span, class: 'd-inline-block', tabindex: 0, data: {toggle: 'tooltip', placement: "right"}, title: "Primero debe seleccionar el expediente" do
        @builder.link_to_add "#{icon('fas', 'plus')} Asociar pedido".html_safe, :surgery_arrival_requests, class: "btn btn-sm btn-success align-self-start disabled new_associated_document", data: {target: '#fieldset'}
      end
    else
      content_tag :span, class: 'd-inline-block', tabindex: 0, data: {toggle: 'tooltip', placement: "right", "original-title" => "Primero debe seleccionar el expediente"}, title: "" do
        @builder.link_to_add "#{icon('fas', 'plus')} Asociar pedido".html_safe, :surgery_arrival_requests, class: "btn btn-sm btn-success align-self-start new_associated_document #{'disabled' if @builder.object.disabled?}", data: {target: '#fieldset'}
      end
    end
  end
end
