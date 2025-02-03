var totalTributos = 0

const getOnlyDetailsTotal = () => {
  var total = 0;
  $("input[id*=attributes][id$=_total]").each((index, detail) => {
    var destroyed = $(detail).closest("tr").find("input[id$=_destroy]").val()
    if (destroyed === "false"){
      total += Math.round10($(detail).val());
    }
  })
  return Math.round10(total);
}

function runTaxes() {
  totalTributos  = 0
  baseImponible  = $("#parent_gross_price").val();

  $('#table-tributes > tbody > tr').each((index, currentField) => {
    setTaxesRowVars($(currentField))
    if (activo) {
      amount       = Math.round10(baseImponible * ( alicuotaTax.val() / 100 ))
      aliquot      = Math.round10()
      totalTributos += Math.round10(amount)
      baseImpTax.val(baseImponible)
      amountTax.val(amount)
    }
  })
  calculateHeader();
}

function setTaxesRowVars(currentField) {
  baseImpTax    = currentField.find('input[id$=_base_imp]')
  amountTax     = currentField.find('input[id$=_amount]')
  selectedTax   = currentField.find('select[id$=_afip_id]').find('option:selected')
  alicuotaTax   = currentField.find('input[id$=_alic]')
  activo        = currentField.find('input[id$=__destroy]').val() == "false"
}

const getTributes = () => {
  var tributes = 0;
  var totalTrib = $("[id$=_total_trib]")
  $('#table-tributes input[id$=_amount]').each((index, currentField) => {
    var destroyed = $(currentField).closest("tr").find("input[id$=_destroy]").val()
    if (destroyed === "false"){
      tributes += Math.round10($(currentField).val())
    }
  })
  if (totalTrib.length && totalTrib.is(":disabled")){
    totalTrib.val(Math.round10(tributes))
  }
  return Math.round10(tributes);
}

const calculateAlicuot = () => {
  totalTributos  = 0
  baseImponible  = $("#parent_gross_price").val();

  $('#table-tributes > tbody > tr').each((index, currentField) => {
    setTaxesRowVars($(currentField))
    if (activo) {
      aliquot      = Math.round10((amountTax.val() / baseImpTax.val()) * 100)
      totalTributos += Math.round10(amountTax.val())
      baseImpTax.val(baseImponible)
      alicuotaTax.val(aliquot)
    }
  })
  calculateHeader();
}


$(document).ready(runTaxes())

$(document).on("change", 'input[id$=_alic]', () => runTaxes())

$(document).on("change", 'input[id$=_alic]', () => calculateHeader())

$(document).on("change", 'input.tribute_amount', () => calculateAlicuot());

$(document).on("nested:fieldAdded:tributes", () => runTaxes())

$(document).on("nested:fieldRemoved:tributes", () => runTaxes())


$(document).on("select2:select", 'select[id$=_afip_id]', function(){
  if ($(this).val() == "99"){
    $(this).closest("div").hide('fast')
    description = $(this).closest('td').find('input[id$=_description]')
    description.closest("div").removeClass("hidden")
    description.attr("type", "text")
    description.removeClass("hidden")
  }else{
    $(this).closest('td').find('input[id$=_description]').closest("div").addClass("hidden")
    $(this).closest("div").show("fast")
    $(this).closest('td').find('input[id$=_description]').val($(this).find("option:selected").text());
  }
});
