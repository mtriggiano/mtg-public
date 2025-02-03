module Sales::DetailsHelper

	def document_detail builder, index, child, editable_number=false, &block
		tr_id 		= child ? "child_#{index}" : "parent_#{index}"
		tr_class	= "fields #{'child child_' + index.to_s if child} #{'hidden' if builder.object.nil? || builder.object.marked_for_destruction?}"
		content_tag :tr, id: tr_id, class: tr_class do
			concat number_td(builder, child, editable_number)
			concat(capture(builder, &block)) if block_given?
		end
	end

	def number_td builder, child, editable_number=false
		content_tag :td do
			concat number(builder, child, editable_number)
		end
	end

	def state_point state
		button_tag "", type: :button,class: 'btn btn-sm btn-info', data: {toggle: 'popover', title: "Estado del detalle", content: detail_state_content(state), html: true} do
			concat(icon('fas', 'info-circle'))
		end
	end

	def detail_type_td builder
		builder.input :detail_type, collection: ["Producto", "Servicio"], include_blank: false
	end

	def detail_state_content state
		content_tag :ul do
			state[:steps].each do |step|
				concat(state_li(step))
			end
		end
	end

	def state_li step
		content_tag :li do
			concat(content_tag :strong, step[:title])
			concat(content_tag :p, step[:description])
		end
	end

	def stock_point bool
		if bool
			content_tag :div, "",class: 'stock-rounded bg-success', data: {toggle: 'tooltip', title: 'Stock disponible'}
		else
			content_tag :div, "",class: 'stock-rounded bg-danger', data: {toggle: 'tooltip', title: 'Stock insuficiente'}
		end
	end

	def branch_td(d)
		d.input :branch, placeholder: "Marca"
	end

	def number(d, child=false, editable_number=false)
		content_tag :div, class: "#{child ? 'child' : 'parent'}_row_number" do
			unless editable_number
				concat content_tag :span, "##{(d.index.to_i + 1).to_i}"
				concat d.input :number, as: :hidden, label: false
			else
				concat d.input :number, label: false
			end
		end
	end

	def product_td(d)
		content_tag :div, class: 'w-100' do
			if d.object.class.abstract_stock || d.object.is_a_service?
				concat(abstract_product d)
			else
				concat(official_product d)
			end
			concat(hidden_field_tag :childs_size, d.object.childs_size)
		end
	end

	def abstract_product d
		d.input :product_name, as: :text, input_html: {rows: 1}
	end

	def official_product d
		content_tag :div do
			concat(
				d.input :product_id,
				input_html: {
					class: 'select2 form-control product_td',
					prompt: "Seleccione...",
					data: {
						url: index_by_company_products_path(current_product: d.object.try(:product_id))
					},
				},
				collection: [[d.object.product_name, d.object.product_id]],
				include_blank: false
			)
	    	concat(d.hidden_field :product_name, class: 'form-control')
	    end
	end

	def nomenclador_td d
		content_tag :div do
			concat(
				d.input :surgery_material_id,
				input_html: {
					class: 'select2 form-control nomenclador_td',
					prompt: "Seleccione...",
					data: {
						url: index_by_company_agreement_surgeries_surgery_materials_path(current_surgery_naterial: d.object.try(:surgery_material_id))
					},
				},
				collection: [[d.object.surgery_material_description, d.object.surgery_material_id]],
				include_blank: false
			)
	    end
	end

	def batch_exit_td(d, path)
		d.association :batches,
			input_html: {
				class: 'select2 form-control w-100',
				prompt: "Seleccione...",
				data: {
					url: path || filter_by_supplier_products_path(),
					extra_data: "[id$=_entity_id]"
				},
			},
			collection: d.object.batches.map{|b| [b.full_text, b.id]}
	end

	def product_code_td(d)
		d.input :product_code, label: false, input_html:{class: 'product_code_td'}
	end

	def quantity_td(d)
		d.input :quantity, input_html:{class: 'quantity_td' ,data: {val: d.object.quantity == 0 ? 1 : d.object.quantity}}
	end

	def requested_quantity_td(d)
		d.input :requested_quantity, input_html:{class: 'requested_quantity_td'}
	end

	def approved_quantity_td(d)
		record = d.object
		class_name = record.class.name.gsub("Detail", "").constantize
		d.input :approved_quantity, input_html: {class: 'approved_quantity_td', disabled: cannot?(:approve, class_name), data: {val: record.quantity == 0 ? 1 : record.quantity}}
	end

	def measurement_td(d)
		d.hidden_field :product_measurement, value: "Unidad"
	end

	def gtin_td(d, for_select=false)
		if for_select
			d.association :gtin, collection: d.object.available_gtins, label: false, disabled: !d.object.traceable?
		else
			d.simple_fields_for :gtin, d.object.gtin || d.object.build_gtin do |g|
				g.input :code, label: false, disabled: !d.object.traceable?, required: false
			end
		end
	end

	def supplier_code_td(d)
		d.input :product_supplier_code, input_html:{class: 'supplier_code_td'}
	end


	def state_td(d)
		d.input :state, collection: d.object.class::STATES, include_blank: false
	end

	def price_td(d, disabled=false)
		d.input :price, input_html:{disabled: disabled, class: 'price_td'}
	end

	def hidden_price_td(d, disabled=true)
	  d.input :price, as: :hidden, input_html: {disabled: disabled, class: 'price_td'}
	end

	def iva_td(d)
		if current_company.iva_cond_sym == :responsable_monotributo
			iva_aliquot =  d.input :iva_aliquot,
			collection: Afip::ALIC_IVA.map{|code, text| [text, code]},
			include_blank: false,
			selected: "03",
			disabled: true,
			wrapper_html: {data: {toggle: 'tooltip', placement: 'top'}, title: "Monotributistas no pueden cargar I.V.A."},
			input_html: {data: {modified: true}, class: 'iva_td'}
		end
		if d.object.persisted?
			iva_aliquot =  d.input :iva_aliquot, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, input_html: {data: {modified: true}, class: 'iva_td'}
		elsif !d.object.parent.nil?
			if d.object.total != 0
				iva_aliquot =  d.input :iva_aliquot, as: :select, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, selected: d.object.iva_aliquot, input_html: {data: {modified: true}, class: 'iva_td'}
			else
				if !d.object.parent.try(:file).nil?
					iva_aliquot =  d.input :iva_aliquot, as: :select, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, selected: d.object.parent.try(:file).try(:iva_aliquot), input_html:{class: 'iva_td'}
				else
					iva_aliquot =  d.input :iva_aliquot, as: :select, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, input_html:{class: 'iva_td'}
				end
			end
		else
			iva_aliquot =  d.input :iva_aliquot, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, input_html: {class: 'iva_td'}
		end
		content_tag :div, class: 'iva' do
			concat iva_aliquot
			concat( d.input :iva_amount, as: :hidden) if d.object.class.column_names.include?("iva_amount")
		end
	end

	def iva_forced_td(d, force_reverse=true)
		if current_company.iva_cond_sym == :responsable_monotributo
			iva_aliquot =  d.input :iva_aliquot,
			collection: Afip::ALIC_IVA.map{|code, text| [text, code]},
			include_blank: false,
			selected: "03",
			disabled: true,
			wrapper_html: {data: {toggle: 'tooltip', placement: 'top'}, title: "Monotributistas no pueden cargar I.V.A."},
			input_html: {data: {modified: true}, class: 'iva_td', 'force-reverse': force_reverse}
		end
		if d.object.persisted?
			iva_aliquot =  d.input :iva_aliquot, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, input_html: {data: {modified: true}, class: 'iva_td', 'force-reverse': force_reverse}
		elsif !d.object.parent.nil?
			if d.object.total != 0
				iva_aliquot =  d.input :iva_aliquot, as: :select, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, selected: d.object.iva_aliquot, input_html: {data: {modified: true}, class: 'iva_td', 'force-reverse': force_reverse}
			else
				if !d.object.parent.try(:file).nil?
					iva_aliquot =  d.input :iva_aliquot, as: :select, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, selected: d.object.parent.try(:file).try(:iva_aliquot), input_html:{class: 'iva_td', 'force-reverse': force_reverse}
				else
					iva_aliquot =  d.input :iva_aliquot, as: :select, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, input_html:{class: 'iva_td', 'force-reverse': force_reverse}
				end
			end
		else
			iva_aliquot =  d.input :iva_aliquot, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, input_html: {class: 'iva_td', 'force-reverse': force_reverse}
		end
		content_tag :div, class: 'iva' do
			concat iva_aliquot
			concat( d.input :iva_amount, as: :hidden) if d.object.class.column_names.include?("iva_amount")
		end
	end

	def iva_without_calc_td(d, calc=true)
		if current_company.iva_cond_sym == :responsable_monotributo
			iva_aliquot =  d.input :iva_aliquot,
			collection: Afip::ALIC_IVA.map{|code, text| [text, code]},
			include_blank: false,
			selected: "03",
			disabled: true,
			wrapper_html: {data: {toggle: 'tooltip', placement: 'top'}, title: "Monotributistas no pueden cargar I.V.A."},
			input_html: {data: {modified: true}, class: 'iva_td', 'calc': calc}
		end
		if d.object.persisted?
			iva_aliquot =  d.input :iva_aliquot, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, input_html: {data: {modified: true}, class: 'iva_td', 'calc': calc}
		elsif !d.object.parent.nil?
			if d.object.total != 0
				iva_aliquot =  d.input :iva_aliquot, as: :select, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, selected: d.object.iva_aliquot, input_html: {data: {modified: true}, class: 'iva_td', 'calc': calc}
			else
				if !d.object.parent.try(:file).nil?
					iva_aliquot =  d.input :iva_aliquot, as: :select, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, selected: d.object.parent.try(:file).try(:iva_aliquot), input_html:{class: 'iva_td', 'calc': calc}
				else
					iva_aliquot =  d.input :iva_aliquot, as: :select, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, input_html:{class: 'iva_td', 'calc': calc}
				end
			end
		else
			iva_aliquot =  d.input :iva_aliquot, collection: Afip::ALIC_IVA.map{|code, text| [text, code]}, include_blank: false, input_html: {class: 'iva_td', 'calc': calc}
		end
		content_tag :div, class: 'iva' do
			concat iva_aliquot
			concat( d.input :iva_amount, as: :hidden) if d.object.class.column_names.include?("iva_amount")
		end
	end

	def discount_td(d)
		d.input :discount, input_html:{class: 'discount_td', max: 100}
	end

	def total_td(d, force_reverse=true)
		d.input :total, input_html: {disabled: !force_reverse, 'force-reverse': force_reverse}
	end

	def document_detail_observation builder, index, child
		tr_id 		= child ? "child_#{index}_observation" : "parent_#{index}_observation"
		tr_class 	= "#{builder.object.errors[:description].blank? ? 'collapse' : 'collapsed'}"
		unless child
	    	content_tag :tr, id: tr_id, class: tr_class do
				content_tag :td, colspan: 10 do
					builder.input :description, as: :summernote
				end
			end
		end
	end

	def document_detail_observation_button builder, index, child
		content_tag :div, class: 'text-center' do
            link_to icon('fas', 'file'), "#parent_#{index}_observation", role: :button, data:{toggle: 'collapse'} unless child
		end
	end

	def document_detail_actions builder, index, child, dont_delete=false
		if child
			child_errors = false
		elsif builder.object.errors.details.keys.map{|k| k.to_s.include?("childs")}.include?true
			child_errors = true
		else
			child_errors = false
		end

		btn_class = child_errors ? 'btn-outline-danger blink' : 'btn-outline-secondary'
		content_tag :div do
    		concat(builder.link_to_add icon('fas', 'plus'), :childs, class: 'btn btn-icon btn-sm btn-outline-secondary', data: {target: "#parent_#{index}"} ) unless child
        	concat(button_tag icon('fas', 'bars'), type: 'button', onclick: "toggleChilds($(this).closest('tr'))", class: "btn btn-sm btn-icon #{btn_class} child_button #{'disabled' unless builder.object.has_childs?}") unless child
        	if dont_delete
        		concat(button_tag icon('fas', 'trash'), type: :button, class: 'btn btn-icon btn-sm btn-light btn-outline-danger dont_delete')
        		concat(builder.link_to_remove icon('fas', 'trash'), class: 'hidden')
        	else
        		concat(builder.link_to_remove icon('fas', 'trash'), class: 'btn btn-icon btn-sm btn-light btn-outline-danger')
	    	end
	    end
	end
end
