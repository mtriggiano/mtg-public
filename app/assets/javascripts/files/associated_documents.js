// Obtiene los detalles en base a los documentos asociados
async function getDetails(element){

  const parent      = element.attr("to") //Obtiene el documento a donde se añade el detalle [request, budget, order...]
  const child       = element.attr("from") //Obtiene el documento desde donde se añade el detalle[request, budget, order...]
  const form        = element.closest("form");
  const document_id = form.attr("document_id");
  const method      = form.find("input[name='_method']").val() || form.attr("method")
  var url           = ""
  if (document_id != null && method == "patch"){
    url       = `${form.attr("action")}/edit`
  }else{
    url       = `${form.attr("action")}/new`
  }

  const params = {
    "number": $("#surgeries_arrival_number").val(), //this field is used only for get anmat transactions.
    "documents": [],
    "file_id": $("#file_select").val(),
    "client_id": $("select[id$=_client_id]").val(),
    "supplier_id": $("select[id$=_supplier_id]").val(),
    "child": child,
    "type": $("select[id$=" + parent + "_type]").val()
  }

  const siblings = $("select.associated_document:visible")

  Array.from(siblings).map( (associated) =>{
      params["documents"].push({document: associated.getAttribute("to"), id: associated.value, method: associated.getAttribute("method"), skip_filter_inheritance: skipFilterInheritance(),})
  })

  $.get(url, params, null, "script")
  .done(function(){
    $.each($("tr[id^=parent_]:visible"), async function( _, obj){
      $(obj).find("[id$=_quantity]").trigger("change")
    })
    setSelect2();
    toogleConceptInTable();
    calculateHeader();
    setDetailsIVA($("#hidden_iva").val());
    recalculateNumbers()
  })
}

const skipFilterInheritance = () => {
  // if ( $("[id$=bill_cbte_tipo").length){
  //   return true
  // }else{
  //   return false
  // }
  return false
}

// Trae los detalles cuando se vincula un document
$(document).on("select2:select", "select.associated_document:not(.abstract):not(.disabled-autocomplete)", function(){
    getDetails($(this))
})

$(document).on("select2:select", "select.associated_document.abstract", function(){
  $("button#sale_order_details").trigger("click")
})

$(document).on("select2:select", ".surgeries_purchase_request_purchase_requests_shipments_shipment select", function(){
  $("button#shipment_details").trigger("click")
})

// Elimina los detalles cuando se desvincula un document
$(document).on('nested:fieldRemoved', function(e){
    const select = e.field.find("select")
    if (select && select.val() != "" && select.hasClass("associated_document")){
        getDetails(select)
    };

})

$(document).on("select2:select", "#file_select", function() {
  checkAssociated();
})


const checkAssociated = () => {
  if ($("#file_select").val() == "") {
    disableAssociations();
  }else {
    enableAssociations();
  }
}

const disableAssociations = () => {
  var associations = $(".new_associated_document");

  associations.each( (index, item) => {
    if (!$(item).hasClass("disabled")) {
      $(item).addClass("disabled").closest("span").tooltip('enable');
    }
  })
}

const enableAssociations = () => {
  var associations = $(".new_associated_document");

  associations.each( (index, item) => {
    if ($(item).hasClass("disabled")) {
      $(item).removeClass("disabled").closest("span").tooltip('disable');
    }
  })
}
