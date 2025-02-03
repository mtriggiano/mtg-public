module ApplicationHelper

	def render_haml(haml, locals = {})
	  Haml::Engine.new(haml.strip_heredoc, format: :html5).render(self, locals)
	end

	def error_notification f
		#f.error_notification message: f.object.errors.empty? ? "Por favor revise los siguientes errores:" : f.error(:base)
		f.error_notification message: f.object.errors[:base].present? ? "Por favor revise los errores" : f.object.errors.map{|attr, msg| "<p> #{attr} => #{msg} </p> "}.join(" ")
	end

	def error_explanation object, flash = {}
    @object = object
    content_tag :div, id: "errors" do
      concat(flash_alerts(flash))
      concat(errors_flash)
    end
  end

  def errors_flash
    if @object.errors.any?
      content_tag :div, class: "alert alert-danger", role: "alert" do
        concat(error_explanation_loop)
      end
    end
  end

  def flash_alerts flash
    html = ""
    unless flash.empty?
      flash.each do |type, msg|
        next if type == "timedout"
        html <<
          "<div class='alert alert-#{["notice", "alert"].include?(type) ? "info" : type}  alert-dismissible' role='alert'>
 						<button type='button' class='close' data-dismiss='alert' aria-label='Close'><span aria-hidden='true'>&times;</span></button>
 				     #{msg}
 				  </div>"
      end
    end
    html.html_safe
  end

	def error_explanation_loop
    content_tag :ul do
      @object.errors.each do |attr, message|
        concat(li_message(attr, message))
      end
    end
  end

  def li_message attr, message
    content_tag :li do
      "#{attr} - #{message}"
    end
  end


	def chart_container(size, icon, text, &block)
		content_tag :div, class: "col-12 col-md-#{size}" do
			chart_card(icon, text, &block)
		end
	end

	def chart_card icon, text, &block
		content_tag :div, class: 'card shadow' do
			concat( chart_header(icon, text) )
			concat( chart_body(&block) )
		end
	end

	def chart_header icon, text
		content_tag :div, class: 'card-header text-muted bg-white' do
			concat( icon('fas', icon) )
			concat( text )
		end
	end

	def chart_body &block
		content_tag :div, class: 'card-body' do
			capture &block if block_given?
		end
	end

	#SIMPLE FORM BUILDER
	def simple_form_builder(record, args={})
		if @s3_direct_post
			args[:html] = {
				document_name: record.class.name.demodulize.snakecase.singularize,
				document_id: record.id.to_s,
				class: 'directUpload',
				data: {
					'form-data' => (@s3_direct_post.fields),
					'url' => @s3_direct_post.url,
					'host' => URI.parse(@s3_direct_post.url).host
				}
			}
		end
		args[:defaults] ||= {disabled: record.disabled?}
		simple_nested_form_for record, args do |f|
			yield f if block_given?
		end
	end
	#SIMPLE FORM BUILDER

	# NOTICE AND ALERT
		def flash_helper
			html = <<-HTML
			<div class="flash-helper">
				<p class="alert-lc alert-lc-success">#{notice}</p>
				<p class="alert-lc alert-lc-danger">#{alert}</p>
			</div>
			HTML
	    	return html.html_safe
		end
	# NOTICE AND ALERT

	#NAVSPAN
		def navspan(text, fa_icon, path, args={})
			args[:class] ||= []
			args[:class] << " text-dark"
			content_tag :li do
				link_to path, args do
					concat(icon('fas', fa_icon))
					concat(content_tag :small, text, class: 'border-animated ml-2')
				end
			end
		end
	#NAVSPAN

	#PRESENTER
		def present(object, klass = nil)
				klass ||= "#{object.class}Presenter".constantize
		    presenter = klass.new(object, self)
		    yield presenter if block_given?
		    presenter
		end
	#PRESENTER

	#SAVE BUTTON
		def save_button(text = nil, custom_class = nil)
			text ||= "#{icon('fas', 'save')} Guardar"
			content_tag :center do
				concat(button_tag text.html_safe, type: 'submit', class: "btn btn-primary text-center #{custom_class}")
			end
		end
	#SAVE BUTTON
	#CLOSE BUTTON
		def close_button
			content_tag :center do
				concat(button_tag "#{icon('fas', 'times')} Cerrar".html_safe, type: 'button', class: 'btn btn-secondary text-center', data:{ dismiss:'modal'})
			end
		end
	#CLOSE BUTTON
	#BACK BUTTON
	def back_button icon = nil
    icon = "chevron-left"
    link_to "#{fa_icon(icon)} Volver".html_safe, :back, class: "btn btn-danger", style: "color:#fff", id: "back_button"
  end
	#BACK BUTTON

	#CURRENCY
		def all_currencies
			Afip::MONEDAS.map{|m, c| [m.to_s.titleize, c[:codigo]] }
		end
	#CURRENCY

	#MODAL
		def modal title, modal_id, modal_body_id, size = 'normal', &block
			case size
			when "normal"
				modal_size = nil
			when "big"
				modal_size = "modal-lg"
			when "extra-big"
				modal_size = "modal-xl"
			end
			html = <<-HTML
			<div class="modal fade" id="#{modal_id}" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
			  <div class="modal-dialog #{modal_size}" role="document">
			    <div class="modal-content">
			      <div class="modal-header">
			        <h5 class="modal-title">#{title}</h5>
			        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
			          <span aria-hidden="true">&times;</span>
			        </button>
			      </div>
			      <div id="#{modal_body_id}">
			      	#{capture(&block) if block_given?}
			      </div>
			    </div>
			  </div>
			</div>
			HTML
			return html.html_safe
		end
	#MODAL

	#LINK TO NEW
		def link_to_new(text, path, opts={})
			link_to "#{icon('fas', 'plus')} #{text}".html_safe, path, {class: 'btn btn-primary flex-shrink-1 border'}.merge(opts)
		end
	#LINK TO NEW

	def link_to_cutom(path, icon_first = 'fas', icon_second = 'edit', opts={})
		link_to icon(icon_first, icon_second), path, {class: 'btn btn-icon btn-sm btn-light btn-outline-secondary'}.merge(opts)
	end

	#LINK TO EDIT
		def link_to_edit(path, opts={})
			link_to icon('fas', 'edit'), path, {class: 'btn btn-icon btn-sm btn-light btn-outline-secondary'}.merge(opts)
		end
	#LINK TO EDIT

	#LINK TO SHOW
		def link_to_show(path, opts={})
			link_to icon('fas', 'eye'), path, {class: 'btn btn-icon btn-sm btn-light btn-outline-secondary'}.merge(opts)
		end
	#LINK TO SHOW

	#LINK TO PDF
		def link_to_pdf(path, opts={})
			link_to icon('fas', 'print'), path, {'data-skip-pjax' => true, target: '_blank', class: 'btn btn-icon btn-sm btn-light btn-outline-secondary'}.merge(opts)
		end
	#LINK TO PDF

	#LINK TO DESTROY
		def link_to_destroy(path, opts={})
			link_to icon('fas', 'trash'), path, {method: :delete, class: 'btn btn-icon btn-sm btn-light btn-outline-secondary', data:{confirm: "¿Está seguro?"}}.merge(opts)
		end
	#LINK TO DESTROY

	#FILTROS
		def filters_for(args={})
			form_tag args[:path], class: 'form-inline', id: 'search_form' do
				concat paginate_filter
				concat right_filters(args[:filters])
			end
		end

		def paginate_filter
			html = <<-HTML
			<div class="input-group mb-2 mr-sm-2">
			  	<div class="input-group-prepend">
			    	<span class="input-group-text" id="basic-addon1">#{icon('fas', 'eye')}</span>
			  	</div>
			  #{select_tag :per_page, options_for_select(["5", "10", "25", "50", "100"], "10"), {class: 'form-control', onchange: "remoteSubmit('#search_form')"}}
			</div>
			HTML
			return html.html_safe
		end

		def right_filters filters
			content_tag :div, class: 'ml-auto' do
				filters.each do |attribute, values|
					case values[:type]
					when "text"
						concat text_field_tag attribute, params[attribute], class: 'form-control mb-2 mr-sm-2', onkeyup: "remoteSubmit('#search_form')", placeholder: values[:placeholder]
					when "select"
						concat select attribute, params[attribute], options_for_select(values[:collection]), {class: 'form-control mb-2 mr-sm-2', onchange: "remoteSubmit('#search_form')"}
					when "date"
						concat text_field_tag attribute, params[attribute], class: 'form-control mb-2 mr-sm-2 datepicker', onkeyup: "remoteSubmit('#search_form')", placeholder: values[:placeholder]
					end
				end
			end
		end
	#FILTROS

	#CUSTOM TABLE
		def custom_table_for(args={}, &block)
			@th_count = args[:th_count]
			if args[:collection].empty?
				concat(show_none)
			else
				args[:collection].each do |object|
					concat(capture(object, &block))
				end
			end
		end

		def show_none
			content_tag :tr do
				content_tag :td, colspan: @th_count, class: 'text-center' do
					concat(content_tag :h5, "¡Todavia no tienes ningún dato cargado!")
				end
			end
		end
	#CUSTOM TABLE

	#SHOW LINKS
		def show_links(text, view, current_view, path, opts={})
			if current_view == view
				link_to text, path, {class: 'nav-link text-success active'}.merge(opts)
			else
				link_to text, path, {class: 'nav-link text-dark'}.merge(opts)
			end
		end
	#SHOW LINKS

	#BADGES
	def badge text, color = nil
		color ||= "info"
		content_tag :span, class: "badge badge-#{color} ml-auto" do
			concat(text)
		end
	end
	#BADGES

	#TABLES
	#path: new_sale_request_path(sale_file_id: @expediente.try(:id)),
	#jpath: sale_requests_path(sale_file_id: try(:sale_file).try(:id), format: :json),
	#config: new_file_attributes_config_path(parent_model: "SaleRequest"),
	#open: @expediente.try(:open)
	def index_table(opts={}, &block)
		opts[:title] ||= true
		opts[:mform] ||= false
		opts[:ltext] ||= "Añadir"
		opts[:fixed] ||= true
		opts[:all_perms] ||= false
		opts[:can_new_path] = opts[:can_new_path].nil? ? true : opts[:can_new_path]
		collection  = opts[:collection] || eval(controller_name.classify.pluralize.snakecase)
		model_name  = opts[:model_name] || collection.model.name
		path 		= opts[:path] || url_for(controller: model_name.demodulize.pluralize.snakecase, action: :new, file_id: @expediente.try(:id), only_path: true) if opts[:can_new_path]
		jpath  		= opts[:jpath] || url_for(controller: model_name.demodulize.pluralize.snakecase, action: :index, file_id: @expediente.try(:id), only_path: true, format: :json)
		config 		= opts[:config].nil? ? new_file_attributes_config_path(parent_model:  model_name) : opts[:config]
		columns 	= opts[:columns] || eval("DatatableConstants::#{model_name}")
		body_columns = columns.merge("actions" => "")
		config_text =  "#{icon("fas", "cogs")} Configurar campos"
		title 		= opts[:text] || t("#{controller_path.gsub("/", ".")}.title", raise: true)
		html = <<-HTML
		<div class='#{opts[:title] == "false" ? "bg-white border" : "index"}'>
		HTML
		unless opts[:title] == "false"
			html << <<-HTML
			<div class='index-title'>
				<div class='principal'>
					#{icon('fas', opts[:icon])}
					#{title}
				</div>
				<div class='buttons d-flex align-items-start'>
					#{ 	if opts[:mtarget]
							if devise_controller? || current_user.can?(:create, model_name.constantize) || opts[:all_perms]
								link_to_new(opts[:ltext], path, data: {toggle: 'modal', target: opts[:mtarget], form: opts[:mform]})
							else
								button_tag("#{icon('fas', 'plus')} #{opts[:ltext]}".html_safe,type: :button, class: 'btn btn-primary disabled', data: {toggle: 'tooltip', title: 'No posees permisos'})
							end
						elsif path
							if current_user.can?(:create, model_name.constantize) || opts[:all_perms]
								link_to_new(
									opts[:ltext],
									path,
									{class: opts[:open] == false ? 'btn btn-primary flex-shrink-1 border disabled' : 'btn btn-primary flex-shrink-1 border'
									}
								)
							else
								button_tag("#{icon('fas', 'plus')} #{opts[:ltext]}".html_safe,type: :button, class: 'btn btn-primary disabled', data: {toggle: 'tooltip', title: 'No posees permisos'})
							end
						end
					}
					#{
						capture(&block) if block_given?
					}
					#{ 	if config
							link_to config_text.html_safe, config, class: 'btn btn-secondary', data: {toggle: 'modal', target: '#config_modal', form: true}
						end
					}
				</div>
			</div>
			HTML
		end
		html << <<-HTML
			<div id='bmenu' class='p-4 d-flex justify-content-between align-items-center'>
			</div>
			<div class='index-body table-responsive'>
				<table class='table' id='paginated_table' data-source='#{jpath}' data-title='#{title}'>
					<thead>
						<tr class='thead-light'>
							#{columns.values.map{|th| "<th scope='col'>" + th[:name] + "</th>" unless th[:name].nil?}.compact.join("")}
							<th class='actions' scope='col'> #{icon('fas', 'bars')} </th>
						</tr>
					</thead>
					<tbody class='table-bordered'>
					</tbody>
				</table>
			</div>
		</div>
		HTML
		content_tag :div do
			concat(html.html_safe)
			concat(table_script(body_columns))
		end
	end

	def table_script columns
		opts = columns.keys
		col_a = opts.map{|d| 
			other_classes = columns[d][:class_name] rescue ""
			{
				data: d, class: "text-truncate #{other_classes}"
			}
		}.to_json
		col_b = columns.to_json
		javascript_tag("setDataTable(#{col_a}, '#{col_b}')")
	end
	#TABLES

	#NEW HELPER
	def new_helper(text, &block)
		html = <<-HTML
		<div class='col-md-8 offset-md-2 col-12'>
			<div class='card'>
				<div class='card-body'>
					<h5 class='card-title'>
						#{icon('fas', 'plus')}
						#{text}
					</h5>
					<hr>
					#{capture(&block) if block_given?}
				</div>
			</div>
		</div>
		HTML
		return html.html_safe
	end
	#NEW HELPER

	#EDIT HELPER
	def edit_helper(text, &block)
		html = <<-HTML
		<div class='col-md-8 offset-md-2 col-12'>
			<div class='card'>
				<div class='card-body'>
					<h5 class='card-title'>
						#{icon('fas', 'edit')}
						#{text}
					</h5>
					<hr>
					#{capture(&block) if block_given?}
				</div>
			</div>
		</div>
		HTML
		return html.html_safe
	end
	#EDIT HELPER


	def panel_card(panel_icon, text, view, current_view, path)
		link_to path, class: "text-dark shadow" do
			content_tag :div, class: "card #{current_view == view ? 'bg-primary text-white' : 'bg-white'} h-100", style: 'width: 10rem;' do
				content_tag :div, class: 'card-body text-center' do
					capture do
						concat(icon('fas', panel_icon, class: 'fa-2x'))
						concat(content_tag :div, text.html_safe, class: 'border-top pt-2 mt-2')
					end
				end
			end
		end
	end

	def state_circle state, text
		if state
			content_tag :div, "", class: 'state-point-success', title: text, data: {toggle: 'tooltip'}
		else
			content_tag :div, "", class: 'state-point-danger', title: text, data: {toggle: 'tooltip'}
		end
	end

	def surgery_state surgery_file
		if surgery_file.open
			content_tag :div, "", class: 'state-point-success', title: surgery_file.state, data: {toggle: 'tooltip'}
		else
			content_tag :div, "", class: 'state-point-danger', title: surgery_file.state, data: {toggle: 'tooltip'}
		end
	end

	def document_pills builder
		content_tag :ul, class: 'nav nav-tabs justify-content-end mx-4 document-options' do
			concat(render '/sales/shared_links', f: builder)
		end
	end

	def document_table f, parent=nil, save_button_presence=true, document_pills=true, can_add=true, &block
		parent ||= controller.class.parent.to_s.snakecase
		hidden_attributes = current_user.table_configs.custom_hidden_attributes(f.object.class.name.snakecase.pluralize)
		html = <<-HTML
			<div class="accordion" id="document-accordion">
				#{document_pills(f) if document_pills}
				#{capture &block if block_given?}
				<div class="card shadow mx-4 mb-4 collapse active show" id="concepts" data-parent="#document-accordion">
					<div class="card-header bg-white">
						<h5 class="w-100 pt-2">
							<span class="dropdown display-th">
								#{button_tag icon('fas', 'cogs'), id: "toggleConceptsButton", type: 'button', class: 'btn btn-light border btn-sm dropdown-toggle', data: {toggle: 'dropdown', for: "#{f.object.class.name.snakecase.pluralize}"}, aria:{haspopup: true, expanded: false}}
								<div class="dropdown-menu"></div>
							</span>
							Conceptos
						</h5>
					</div>
					<div class="card-body">
						<div class="table-responsive">
							<table class="table parent-table">
								<thead>
									<tr>
										#{document_table_th(f, hidden_attributes)}
									</tr>
								</thead>
								<tbody>
									#{ render "/#{parent}/shared_details_form", f: f }
								</tbody>
							</table>
						</div>
						#{document_footer(f, save_button_presence, '', can_add)}
					</div>
				</div>
			</div>
		HTML
		return html.html_safe
	end

	def document_table_th f, hidden_attributes
		html = ""
		("#{f.object.class.name}Detail").constantize::TABLE_COLUMNS.each do |detail, options|
			html << "<th class='#{'hidden' if hidden_attributes.include? detail} #{'important' if options["important"]} #{'fixed-col' if  options["fixed"]}'> #{detail} </th>"
		end
		return html
	end

	def observation_to_user(text)
		content_tag :small, class: 'text-muted' do
			concat("#{icon('fas', 'exclamation-circle')} #{text}".html_safe)
		end
	end

	def pdf_button(object)
	 # klass = object.class.name.snakecase.split("/").map(&:singularize).join("_").pluralize
	 # pp "TIENE PDF? #{object.has_pdf?} CLASE: #{object.class.name}"
	 	if object.has_pdf? && !object.new_record? && object.approved?
		 	content_tag :span, class: 'justify-content-center w-100 mt-3' do
				concat(link_to "#{icon('fas', 'file-pdf')} PDF".html_safe, url_for(controller: object.class.name.demodulize.pluralize.snakecase, action: :show, format: :pdf), target: '_blank', class: 'nav-link bg-white collapsed btn-outline-info text-success', data: {"skip-pjax" => true})
			end
		end
	end

	def dolar_variation cotization
    if cotization.to_f > 0
      html = "<span class='pull-right text-green'> #{cotization} #{icon('fas','arrow-up')} <span>".html_safe
    elsif cotization.to_f < 0
      html = "<span class='pull-right text-red'> #{cotization} #{icon('fas', 'arrow-down')} <span>".html_safe
    else
      html = "<span class='pull-right'> #{cotization} #{icon('fas', 'minus')} <span>".html_safe
    end

    return html
  end

  def link_o_texto(record)
  	can?(:show, record) ? (link_to record, record) : record if record
  end

  def fecha_stamp(fecha)
  	I18n.l(fecha, format: :long)
  end

  def track_users(record)
	html = <<-HTML
		<p>
		  <strong>Creado por:</strong>
		  <span class="text-muted">#{ link_o_texto record.user }</span>
		  <strong>En la fecha:</strong>
		  <span class="text-muted">#{ fecha_stamp record.created_at }</span>
		</p>        

		<p>
		  <strong>Actualizado por:</strong>
		  <span class="text-muted">#{ link_o_texto record.updated_by }</span>
		  <strong>En la fecha:</strong>
		  <span class="text-muted">#{ fecha_stamp record.updated_at }</span>
		</p>
	HTML
  	html.html_safe
  end
end
