$(document).on("change focusout", ".solo-numeros", function() {
  if (isNaN($(this).val()) || !$(this).val()) {
    $(this).val("0").trigger("change")
  }
}).on("focusin", ".solo-numeros", function() {
  $(this).val("")
})

$(document).on("change", ".monedas-a-rendir", function() {
  calculaTotalARendir()
})

$(document).on("change", ".monedas-en-caja", function() {
  calculaMonedasEnCaja()
})

$(document).on("ready pjax:complete", function() {
  calculaTotalARendir()
  calculaMonedasEnCaja()
})

function calculaTotalARendir() {
  aRendir = parseFloat(0)
  $(".monedas-a-rendir").each(function() {
    denominacion = $(this).data("value")
    cantidad = $(this).val()
    $(this).closest(".fields").find(".subtotal").text(denominacion * cantidad)
    aRendir += denominacion * cantidad
  })
  $(".corder-subtotal").val(aRendir)
}

function calculaMonedasEnCaja() {
  enCaja = parseFloat(0)
  $(".monedas-en-caja").each(function() {
    denominacion = $(this).data("value")
    cantidad = $(this).val()
    $(this).closest(".fields").find(".subtotal").text(denominacion * cantidad)
    enCaja += denominacion * cantidad
  })
  $("#imprest_clearing_saldo_en_caja").val(enCaja)
}

function renderTransactionTable(date) {
  $("#fecha_de_busqueda").val(date);
  remoteSubmit("#date_form")
}
