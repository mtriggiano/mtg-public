module Purchases::ApplicationPurchasesHelper

	def supplier_select(builder)
		builder.association :supplier,
		as: :select,
		input_html: {
			include_blank: "Seleccione...",
			data: {
				url: index_by_company_suppliers_path
			}
		}
	end

	def supplier_contact_select builder
		builder.association :supplier_contact,
		as: :select,
		input_html: {
			include_blank: "Seleccione...",
			data: {
				url: index_by_supplier_supplier_contacts_path,
				extra_data: "[id$=entity_id]"
			}
		}
	end

  	def product_with_supplier(builder, associated_str)
    	@builder = builder
    	@associated_klass = "purchase_#{associated_str}".to_sym
    	builder.association :product, as: :select, label: false, value_method: :id, label_method: :name, input_html: {data: {url: eval("index_by_supplier_#{@associated_klass.to_s.pluralize}_path"), extra_data: "##{@builder.object.class.name.snakecase.to_s}_supplier_id"}}
  	end

  	def new_associated_purchase_document builder, associated_str, associated_str_es
		@builder = builder
		@associated_str_es = associated_str_es
		@builder_klass = builder.object.class.name == 'PurchaseRequest' ? "purchase_request_sale_orders" : "#{builder.object.class.name.snakecase}_#{associated_str.pluralize}".to_sym
		@associated_klass = builder.object.class.name == 'PurchaseRequest' ? "sale_#{associated_str}".to_sym : "purchase_#{associated_str}".to_sym
		html = <<-HTML
			<div class="row">
				<div class="col-2">
					#{button_to_add_associated_purchase}
				</div>
				<div class="col-10 d-flex flex-wrap" id="fieldset">
					#{builder.simple_fields_for(@builder_klass, wrapper: false) {|p| concat(associated_purchases_fields(p))}}
				</div>
			</div>
		HTML
		return html.html_safe
	end

	def associated_purchases_fields p
		if @associated_klass != :sale_order
			association = p.association @associated_klass, as: :select, label: false, value_method: :id, label_method: :number, input_html: {data: {url: eval("index_by_file_#{@associated_klass.to_s.pluralize}_path"), extra_data: "#file_select"}}
		else
			association = p.association @associated_klass, as: :select, label: false, value_method: :id, label_method: :number, collection: current_company.sale_orders.approveds
		end
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

  def button_to_add_associated_purchase
    if @builder.object.purchase_file_id.blank? && params[:purchase_file_id].blank?
      content_tag :span, class: 'd-inline-block', tabindex: 0, data: {toggle: 'tooltip', placement: "right"}, title: "Primero debe seleccionar el expediente" do
        @builder.link_to_add "#{icon('fas', 'plus')} Asociar #{@associated_str_es}".html_safe, @builder_klass, class: "btn btn-sm btn-success align-self-start disabled new_associated_document", data: {target: '#fieldset'}
      end
    else
      content_tag :span, class: 'd-inline-block', tabindex: 0, data: {toggle: 'tooltip', placement: "right", "original-title" => "Primero debe seleccionar el expediente"}, title: "" do
        @builder.link_to_add "#{icon('fas', 'plus')} Asociar #{@associated_str_es}".html_safe, @builder_klass, class: "btn btn-sm btn-success align-self-start new_associated_document #{'disabled' if @builder.object.disabled?}", data: {target: '#fieldset'}
      end
    end
  end



	def purchase_mail_modal jfunction, object
		html = <<-HTML
		<div class="modal-body">
		  	Datos del proveedor
		  	<br>
		  	<br>
		  	<div class="form-group row">
		    	#{label_tag :name, "Proveedor", class: 'col-sm-3 col-form-label col-form-label-sm'}
		    	<div class="col-md-8">
		      	#{text_field_tag :client_name_modal, object.supplier.name , class: 'form-control form-control-sm', autocomplete: false, disabled: true }
		    	</div>
		  	</div>

		  	<div class="form-group row">
		    	#{label_tag :email, "Email", class: 'col-sm-3 col-form-label col-form-label-sm'}
		    	<div class="col-md-8">
		     		#{text_field_tag :email, object.supplier.emails , class: 'form-control form-control-sm', id: 'send_email_tag'}
		    	</div>
		  	</div>
		  <br>

		</div>

		<div class="modal-footer">
		  	#{button_tag "#{icon('fas', 'arrow-circle-right')} Enviar".html_safe, class: 'btn btn-primary',type:'button', onclick: "#{jfunction}", data: {disable_with: "#{icon('fas', 'sync')} Enviando..."}}
		  	#{close_button}
		</div>
		HTML
		return html.html_safe
	end


end
