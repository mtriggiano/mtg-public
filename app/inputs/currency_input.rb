class CurrencyInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_options = input_html_options.merge({data: {autonumeric: true}})
    wrapper_options = wrapper_options.merge({ data: { "digitGroupSeparator": '.', "autonumeric-decimalCharacter": "," } })
    merged_input_options = merge_wrapper_options(input_options, wrapper_options)

    template.content_tag(:div, class: 'input-group') do
      template.concat div_prepend_group
      template.concat @builder.text_field(attribute_name, merged_input_options)
    end
  end

  def div_prepend_group
    template.content_tag(:div, class: 'input-group-prepend') do
      template.concat span_dollar_sign
    end
  end

  def span_dollar_sign
    template.content_tag(:span, class: 'input-group-text') do
      template.concat '$'.html_safe
    end
  end
end
