

$(document).on("change", "#product_supplier_price, #product_margin_gain, #product_iva_aliquot", function(){
  calculo_precio();
})

function calculo_precio(){
  var sup_price = parseFloat($("#product_supplier_price").val());
  var percentage = parseFloat($("#product_margin_gain").val());
  if (isNaN(percentage))
    {
      percentage = 0
    }
  if ((sup_price > 0) & (percentage >= 0)) {
    var neto = sup_price * ( 1 + (percentage / 100));
    $("#product_gross_price").val(round(neto, 2));
    var iva = parseFloat($("#product_iva_aliquot option:selected").text());
    if (iva >= 0) {
      neto = round(neto * (1 + iva), 2);
      $("#product_price").val(neto);
    } else if ($("#product_iva_aliquot option:selected").text() == "No gravado") {
      neto = round(neto, 2);
      $("#product_price").val(neto); //CHEQUEAR
    } else {
      neto = round(neto, 2);
      $("#product_price").val(neto); //CHEQUEAR
    }
  }
}


function allowDrop(ev) {
  ev.preventDefault();
}

function drag(ev) {
  ev.dataTransfer.setData("tr", $(ev.target).attr("id") )
  ev.dataTransfer.setData("image", $(ev.target).find("img").attr("src"));
  ev.dataTransfer.setData("product_id", $(ev.target).find("td:last").attr("id"));
  ev.dataTransfer.setData("product_name", $(ev.target).find("td:last").html());
}

function drop(ev) {
  ev.preventDefault();
  if ($(ev.target).hasClass("droppable")) {
    var src         = ev.dataTransfer.getData("image");
    var product_id  = ev.dataTransfer.getData("product_id");
    var product_name  = ev.dataTransfer.getData("product_name");
    $(ev.target).attr("src", src);
    div = $(ev.target).closest(".parent_div")
    div.find("input.quantity.transparent").attr("style", "visibility:initial; opacity: 1;");
    div.find("a.remove_nested_fields").attr("style", "visibility:initial; opacity: 1;");
    div.find("input.product_id").val(product_id);
    div.find("div.product_name").html(product_name)
    $("#" + ev.dataTransfer.getData("tr")).hide("slow");
  }
}

$(document).on('nested:fieldRemoved:box_products', function(event){
  box = $(event.target).find("input[id$=_product_id]").val()
  $("tr#" + box).show();
})

$(document).on("keyup", "#search-input", function(){
  var excluded  = [];
  const own = $("#box_own").is(":checked");

  $("div.parent_div:visible").each(function(){
    product_id = $(this).find("input[id$=_product_id]").val();
    if (product_id != null && product_id != ""){
      excluded.push(product_id)
    }
  })

  var unique = excluded.filter(function(elem, index, self) {
      return index === self.indexOf(elem);
  })
  console.log(unique)
  action = "/boxes/search";
  //action = window.location.href;
  $.get(action, {search: $(this).val(), exclude: unique, own }, null, "script" )
})

$(document).on("change", "#box_own", function(){
  $("#search-input").trigger("keyup")
})

$(document).on("ready pjax:complete ajaxComplete", function(){
  if ($("#search-input").length){
    $("#search-input").trigger("change")
  }
})