$(document).on("ready pjax:complete", function() {
  $(".boton-cambio-cheque").click(() => {
    $(".contenedor-cambio-cheque").toggle();
    $(".boton-cambio-cheque").toggle();
    $(".boton-registrar-deposito").toggle();
  })
})
