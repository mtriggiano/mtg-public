module Files::InputsHelper

	def file_input f
		record = f.object
		content_tag :div, class: 'd-flex align-items-center' do
			concat(f.association :file,
			as: :select,
			label: "Expediente",
			selected: params[:file_id] || record.file.try(:id),
			wrapper: :horizontal_file,
			include_blank: "Seleccione...",
			wrapper_html: {class: 'mr-3'},
			input_html: {
				id: "file_select",
				class: 'w-100',
				data:{
					type: record.class.name.deconstantize.snakecase.pluralize,
					url: polymorphic_path([:index_by_company, record.class.name.deconstantize.underscore.pluralize.to_sym, :files])
				},
			})
		end
	end

	def currency_input f
	  # record = f.object
		content_tag :div  do
			concat(f.input :currency,
				as: :select,
				label: "Moneda",
				selected: "ARS",
				input_html: {
					id: 'parent_currency',
					class:'w-100'
				},
				collection: ["ARS", "USD"],
				selected: f.object.new_record? ? "ARS" : f.object.try(:currency)
			)
		end
	end

	def number_input builder, editable=false
		if editable
			builder.input :number, placeholder: "Número del comprobante"
		else
			builder.input :number, placeholder: "Generado automáticamente al guardar", input_html: {disabled: true}
		end
	end

	def offer_input builder
		builder.input :base_offer,
			label: false,
			input_html: {
				checked: builder.object.new_record? ? true : builder.object.base_offer,
				data: {
					toggle: 'toggle',
					onstyle: 'success',
					offstyle: "#{builder.object.errors.any? ? 'light blink' : 'light'}",
					on: "Base",
					off: "Alternativo"
				}
			}
	end

	def iibb_perception_input builder
		builder.input :iibb_perception,
			label: "Percepción IIBB?",
			input_html: {
				checked: false,
				data: {
					toggle: 'toggle',
					onstyle: 'success',
					offstyle: "#{builder.object.errors.any? ? 'light blink' : 'light'}",
					on: "SI",
					off: "NO"
				}
			}
	end

	def supplier_input builder, selected = nil
		builder.association :supplier, collection: current_company.suppliers, label_method: :name, prompt: "Seleccione...", selected: selected || builder.object.entity_id, input_html: {data: {type: 'supplier'}}
	end

	def client_input builder, selected = nil
		builder.association :client, collection: current_company.clients, label_method: :name, prompt: "Seleccione...", selected: selected || builder.object.entity_id, input_html: {data: {type: 'client'}}
	end

	def user_input builder
		builder.association :user, selected: current_user.id, input_html: {readonly: true}, collection: [[current_user.name, current_user.id]]
	end

	def date_input builder, sym, disabled=false
		builder.input sym, as: :date_picker, disabled: disabled, value: (builder.object.new_record? && builder.object[sym].blank?) ? Date.today : builder.object[sym]
	end

	def numbers_input builder, sym, disabled=false
	  builder.input sym, disabled: disabled
	end

	def punctuation_input builder
		builder.input :punctuation, collection: 1..10
	end

	def observation_input builder, &block
		content_tag :div, class: 'card shadow mx-4 mb-4 collapse w-100 pb-4', id: 'observation', data: {parent: '#document-accordion'} do
			concat(observation_header)
			if block_given?
				concat(capture(&block))
			else
				concat(observation_body(builder))
			end
			concat save_button if builder.object.editable?
		end
	end

	def observation_header
		content_tag :div, class: 'card-header bg-white' do
			content_tag :h5, "Observaciones", class: 'w-100 pt-2'
		end
	end

	def observation_body builder
		content_tag :div, class: 'card-body d-flex' do
			concat(builder.input :observation, as: :summernote, placeholder: true, label: false, wrapper: :inline_input, wrapper_html: {class: 'w-100 mx-3'}, input_html: {height: 150})
		end
	end

	def note_input builder, &block
		content_tag :div, class: 'card shadow mx-4 mb-4 collapse w-100 pb-4', id: 'note', data: {parent: '#document-accordion'} do
			concat(note_header)
			if block_given?
				concat(capture(&block))
			else
				concat(note_body(builder))
			end
			concat save_button if builder.object.editable?
		end
	end

	def note_header
		content_tag :div, class: 'card-header bg-white' do
			content_tag :h5, "Nota al cliente", class: 'w-100 pt-2'
		end
	end

	def note_body builder
		content_tag :div, class: 'card-body d-flex' do
			concat(builder.input :note, as: :summernote, placeholder: true, label: false, wrapper: :inline_input, wrapper_html: {class: 'w-100 mx-3'}, input_html: {height: 150})
		end
	end

	def store_input builder
		builder.association :store, collection: current_company.stores.map{|po| [po.name, po.id]}
	end

	def discount_input builder
		builder.input :discount, input_html:{id: 'parent_discount', disabled: true}
	end

	def subtotal_input builder
		builder.input :subtotal, input_html:{id: 'parent_subtotal', disabled: true}
	end

	def total_input builder, disabled=true
		builder.input :total, input_html:{id: 'parent_total', disabled: disabled}
	end

	def expected_delivery_date_input builder
		builder.input :expected_delivery_date, as: :date_picker
	end


	def total_usd_input builder, disabled=true
		builder.input :total_usd, input_html:{id: 'parent_total_usd', disabled: disabled}
	end

	def usd_price_input builder, disabled=false
		today_dolar = TodayDolarGetter.new.call.second
	  builder.input :usd_price, input_html: {id: 'parent_usd_price', disabled: disabled, value: builder.object.new_record? ? today_dolar : builder.object.usd_price, data: {default: today_dolar}}
	end

	def shipping_input builder
		concat(builder.label :shipping_included)
		content_tag :div, class: 'd-flex' do
			concat(shipping_included_input(builder))
			concat(shipping_price_input(builder, !builder.object.shipping_included ))
		end
	end

	def shipping_included_input builder
		builder.input :shipping_included,
			label: false,
			input_html: {
				data: {
					toggle: 'toggle',
					onstyle: 'success',
					offstyle: 'danger',
					on: "Incluye",
					off: "No incluye"
				}
			},
			wrapper_html: {
				class: 'flex-grow-1',
				style: 'margin-left: -1.25rem; padding-right: 1.25rem;'
			}
	end

	def shipping_price_input builder, disabled=false, label=false
		builder.input :shipping_price,
			label: label,
			input_html: {
				disabled: disabled
			}
	end

	def state_input(builder, opts={})
		record = builder.object
		builder.input :state, disabled: true, input_html: {id: "current_state"}
	end

	def budget_state_input(builder)
	  record = builder.object
		builder.input :budget_state, as: :select, collection: ExpedientBudget::BUDGET_STATES
	end

  	def client_contact_input builder
  		record = builder.object
  		builder.association :client_contact,
  		input_html: {
  			disabled: record.disabled? || record.file.try(:client_id).nil?,
  			data:{
  				url: client_contacts_path,
  				extra_data: "##{record.class.name.snakecase.gsub("/", "_")}_entity_id"
  			}
  		}
  	end
end
