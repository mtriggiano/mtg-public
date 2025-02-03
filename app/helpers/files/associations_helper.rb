module Files::AssociationsHelper
	def new_associated_document builder, method = :assign, type = 'official', confirmed=nil
		record 				= builder.object
		case method
		when :assign
			associated_str	= record.class.inherit_details_from.to_s.pluralize
		when :secondary_assign
			associated_str	= record.class.secondary_assign_details_from.to_s.pluralize
		when :filter
			associated_str  = record.class.filter_details_from.to_s.pluralize
		when :rest
			associated_str  = record.class.rest_details_from.to_s.pluralize
		else
			associated_str  = record.class.filter_details_from.to_s.pluralize
		end
		builder_klass 		= "#{builder.object.class.name.demodulize.snakecase.pluralize}_#{associated_str}".to_sym
		document_name 		= builder.object.class.name.demodulize.snakecase
		content_tag :div, class: "d-flex mb-1 pt-4" do
			concat( content_tag :div, button_to_add_associated(builder, builder_klass, method), class: 'form-group' ) unless confirmed
			concat(content_tag :div, builder.simple_fields_for(builder_klass, wrapper: false){|n| associated_fields(n, associated_str,document_name, method, type, confirmed) }, class: "fieldset #{builder_klass} d-flex flex-wrap ")
		end
	end

	def associated_fields n, associated_str, parent_class_name, method, type, confirmed
		record 				= n.object
		if eval("#{parent_class_name}.file.nil?")
			if eval("record.#{associated_str.singularize}").nil?
				association_collection = []
			else
				association_collection = [eval("record.#{associated_str.singularize}")]
			end
		else
			association_collection = eval("#{parent_class_name}.file.#{associated_str.pluralize}")
		end
		parent_class_sym 	= record.class.reflect_on_association(associated_str.singularize.to_sym).class_name.snakecase.gsub("/", "_").pluralize #index_by_file_surgeries_prescriptions
		association 		= n.association associated_str.singularize.to_sym,
								as: :select,
								label: false,
								value_method: :id,
								label_method: :number,
								collection: association_collection,
								wrapper_html: {class: 'associated-doc'},
								input_html: {
									to: associated_str.singularize.to_sym,
									from: parent_class_name,
									autofocus: true,
									class: "associated_document #{type} #{confirmed ? '.disabled-autocomplete': ''}",
										method: method,
									data: {
										url: polymorphic_path(
											[parent_class_sym],
											from: parent_class_name
										),
										extra_data: "#file_select"
									}
								}
		remove_button 		= n.link_to_remove icon('fas', 'trash'), class: "btn btn-danger btn-sm"
		content_tag :div, class: 'fields association-field' do
			content_tag :div, class: 'px-2 d-flex small-form' do
				concat( association )
				concat( content_tag :div, remove_button, class: 'input-group-append mb-3')
			end
		end
	end



	def button_to_add_associated builder, builder_klass, method
		text = "#{icon('fas', 'plus')} #{method == :assign ?  t('.associated_document', raise: true) : ( method == :secondary_assign ? t('.secondary_document') : t('.filter_document'))}"
		content_tag :span, class: 'd-inline-block', tabindex: 0, data: {toggle: 'tooltip', placement: "right"}, title: t('.associated_document_span', raise: true) do
			builder.link_to_add text.html_safe, builder_klass ,class: "btn btn-success btn-sm disabled new_associated_document", data: {target: ".fieldset.#{builder_klass}"}
		end
	end
end
