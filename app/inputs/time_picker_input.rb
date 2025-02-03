class TimePickerInput < SimpleForm::Inputs::StringInput
  def input_html_options
    value = object.send(attribute_name)
    options = {
      value: value.respond_to?(:to_date) && !value.blank? ? I18n.localize(value.to_time, format: :time) : nil,
      autocomplete: :off,
      data: { behaviour: 'timepicker' }
    }
    super.merge options
  end
end
