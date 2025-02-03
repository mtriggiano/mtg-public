module UtilitiesHelper
  def number_to_ars number
    number_to_currency( number, unit: "$", format: "%u %n", seperator: ',', delimiter: '.')
  end

  def number_to_us number
    number_to_currency( number, unit: "U$S", format: "%u %n", seperator: ',', delimiter: '.')
  end

  def negative_colored_number_klass number
    return "text-danger" if number < 0
  end

  def number_to_words unidad="pesos", valor
    valor_con_decimales = ActiveSupport::NumberHelper::NumberToRoundedConverter.convert(valor, precision: 2)
    enteros  = I18n.with_locale(:es) { valor_con_decimales.split(",").first.to_i.to_words ordinal: true }
    centavos = I18n.with_locale(:es) { valor_con_decimales.split(",").last.to_i.to_words ordinal: true }
    return "#{enteros} #{unidad} con #{centavos} centavos"
  end
end
