//Cuando el transporte esta incluido despliega el precio. Caso contrario lo setea en 0
$(document).on("change", "input[name$='[shipping_included]']", function() {
  price = $("input[name$='[shipping_price]']")
  if ($(this).is(":checked")) {
    price.removeAttr("disabled");
    removeDisabledTooltip(price);
  } else {
    price.attr("disabled", "disabled");
    price.val(0).trigger("change")
    setDisabledTooltip(price);
  }
});

$(document).on("change", "input[id$=_shipping_price]", function() {
  calculateHeader()
})
