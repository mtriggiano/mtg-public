//Popovers en los precios de los detalles. Se usa para ver el historial de precios del producto
$(document).on("ready", function() {
  $("[id^=purchase_][id$=_price]").each(function() {
    $(this).attr("data-toggle", "popover");
  })
})

$.fn.populatePricePopover = function(data){
  const popover_id = $(this).attr('aria-describedby')
  $(`#${popover_id} > .popover-body`).html(data)
}


$.fn.initializePricePopover = function() {
  content         = $("<div></div>")
  list            = $("<ul class='mt-3'></ul>");
  $(this).popover({
    trigger: 'manual',
    template: '<div class="popover" style="max-width: 30rem;" tabindex="-1"><div class="arrow"></div><h3 class="popover-header"></h3><div class="popover-body"></div></div>',
    html: true,
    title: "Historial de precios",
    content: "<center><img src='/images/preload.gif' class='avatar'></center>"
  })
  $(this).popover("show")
}

$.fn.fillPopover = function(product, entity, flow){
  const entity_id   = entity.val()
  const price_input = $(this)
  const currency = $("#parent_currency").val();
  //if (currency == "ARS") {
  var currency_label = "$"

  //else {
    //var currency_label = "USD"
  //}
  $.get(`/inventaries/${product.val()}/${flow}_price_history`, {entity_id: entity_id}, null, "json")
  .done(function(response) {
    if (response.length){
      if (response[1] != null){
        list.append(`<strong>Ultima cotización a ${response[1]["client"]}</strong>`);
        list.append(`<li><a href="javascript:void(0)" onclick="setPrice(${response[1].price}, '#${price_input.attr("id")}')">${currency_label} ${response[1].price} - ${response[1].date}</a></li>`);
      }
      if (response[0] != null){
        list.append("<strong>Última cotización realizada (general)</strong>")
        list.append(`<li><a href="javascript:void(0)" onclick="setPrice(${response[0].price}, '#${price_input.attr("id")}')">${currency_label} ${response[0].price} - ${response[0].date} - cliente: ${response[0].client}</a></li>`);
      }
      var ol = $("<ol></ol>")
      ol.append("<li class='text-muted'>Primero especifique el margen de ganancia que desea obtener respecto a la cotización a elegir.</p>")
      ol.append("<li class='text-muted'>Luego seleccione la cotización a la que desea aplicar el margen de ganancia.</li>")
      content.append(ol)
      content.append(gainCalculator)
      content.append(list)
    }else{
      list.append("<p class='text-muted'>Todavia no se registro ningun historial de precios para este producto.</p>")
      content.append(list)
    }
    content.append("<hr class='dotted'><div class='actions text-center'><button type='button', class='btn btn-secondary' onclick='dismisPopover()'>Cerrar</button></div>")
    price_input.populatePricePopover(content)
  })
}

var   content         = $("<div></div>")
const gainCalculator  = $("<div class='form-inline'><label class='col-form-label px-2'>Ganancia(%)</label><input type='number' id='gain_margin' class='form-control' placeholder='0'/></div>");
var   list            = $("<ul class='mt-3'></ul>");

$(document).on("dblclick", "input.purchase_price_history", function(a,b) {

  if (!b){
    const price_input = $(this)
    const product     = $(this).closest("tr").find("select[id$=_product_id]")
    const supplier    = $("select[id$=_entity_id]")

    price_input.initializePricePopover()

    if (supplier.blank()){
      list.append("<p class='text-muted'>Primero debe seleccionar el proveedor.</p>")
      price_input.populatePricePopover(list)
      $(".popover-body").append("<hr class='dotted'><div class='actions text-center'><button type='button', class='btn btn-secondary' onclick='dismisPopover()'>Cerrar</button></div>")

      return true
    }

    if (product.blank()){
      list.append("<p class='text-muted'>Primero debe seleccionar el producto.</p>")
      price_input.populatePricePopover(list)
      $(".popover-body").append("<hr class='dotted'><div class='actions text-center'><button type='button', class='btn btn-secondary' onclick='dismisPopover()'>Cerrar</button></div>")

      return true
    }
    price_input.fillPopover(product, supplier, "purchase")
  }
});

function dismisPopover() {
  const popover_id = $(".popover.show").attr("id")
  $(".popover.show").popover('dispose')
  $(`input[aria-describedby='${popover_id}']`).focus();
}

$(document).on("dblclick", "input.sale_price_history", function() {
  const price_input = $(this)
  const product     = $(this).closest("tr").find("select[id$=_product_id]")
  const client      = $("select[id$=_entity_id]")

  price_input.initializePricePopover()

  if (product.blank()){
    list.append("<p class='text-muted'>Primero debe seleccionar el producto.</p>")
    price_input.populatePricePopover(list)
    $(".popover-body").append("<hr class='dotted'><div class='actions text-center'><button type='button', class='btn btn-secondary' onclick='dismisPopover()'>Cerrar</button></div>")

    return true
  }
  price_input.fillPopover(product, client, "sale")
});

function setPrice(price, input){
  gain = ($("#gain_margin").val() / 100) + 1
  $(input).val(price * gain).trigger("change")
  dismisPopover()
}
