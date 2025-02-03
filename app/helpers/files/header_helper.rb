module Files::HeaderHelper

	def file_header f, without_file=false, &block
		content = block_given? ? capture(&block) : ""
		content_tag :div, class: 'pb-3 mb-3 border-bottom' do
			concat(header(f, content, without_file))
		end
	end

	def header f, content, without_file=false
		content_tag :div, class: 'title file-header d-flex justify-content-between' do
			concat(document_title(content, f.object))
			unless without_file
				concat(file_input(f))
			end
			concat(hidden_field_tag "hidden_iva", "03")
		end
	end

	def payment_header f, &block
		content = block_given? ? capture(&block) : ""
		content_tag :div, class: 'pb-3 mb-3 border-bottom' do
			concat(header(f, content, true))
		end
	end

	def shared_nav f
		record = f.object
		render partial: "/#{record.class.name.deconstantize.snakecase}/shared_nav", locals: {document: record}
	end


	def document_title content, record
		content_tag :div do
			concat(header_title(record))
			concat(content)
		end
	end

	def header_title record
		content_tag :h5 do
			concat(button_tag icon('fas', 'eye-slash'), onclick: 'toggleHeader()', type: 'button', class: 'btn btn-outline-dark rounded-circle border btn-sm mr-1')
			concat(translate('.title', raise: true))
			concat(content_tag :span, record.number, class: 'small ml-1 text-muted') unless record.number.blank?
		end
	end
end
