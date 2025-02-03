class BasePresenter

  def initialize(object, template)
    @object   = object
    @template = template
  end

  def action_links
    
  end

private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @template
  end

  def markdown(text)
    Redcarpet.new(text, :hard_wrap, :filter_html, :autolink).to_html.html_safe
  end

  def sanitize(text)
    ActionController::Base.helpers.sanitize text
  end

  def method_missing(name, *args, &block)
    attribute = @object.read_attribute(name)
    unless attribute
      @template.send(name, *args, &block)
    end
  end

  def handle_none(value)
    if value.present?
      value
    else
      h.content_tag :span, "Sin especificar", class: "none"
    end
  end

  def handle_date(value)
    unless value.blank?
      I18n.l(value, format: :short)
    else
      "Sin especificar"
    end
  end

  def handle_date_long(value)
    if not value.blank?
      I18n.l(value, format: :long)
    else
      "Sin especificar"
    end
  end

  def handle_time(value)
    if not value.blank?
      I18n.l(value, format: :time)
    else
      "Sin especificar"
    end
  end

  def handle_currency(value, unit="$")
    if not value.blank?
      number_to_currency( value, unit: unit, format: "%u %n", seperator: ',')
    else
      "Sin especificar"
    end
  end

  def handle_months(value)
    case value
    when 1
      "Enero"
    when 2
      "Febrero"
    when 3
      "Marzo"
    when 4
      "Abril"
    when 5
      "Mayo"
    when 6
      "Junio"
    when 7
      "Julio"
    when 8
      "Agosto"
    when 9
      "Septiembre"
    when 10
      "Octubre"
    when 11
      "Noviembre"
    when 12
      "Diciembre"
    else
      "Sin especificar"
    end
  end

  def state(span, text)
    handle_state(span, text)
  end

  def estado_entrada(span, text)
    handle_state(span, text)
  end

  def handle_state state, text
    h.content_tag :div, text, class: "text-#{state} font-weight-bold text-center w-100"
  end
end
