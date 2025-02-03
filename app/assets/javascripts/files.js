var $index = {};
$(document).on("ready ajaxComplete pjax:complete", function() {
  $("*[data-toggle='tooltip']:not([title=''])").tooltip()
  $("*[data-toggle='popover']").popover()
  setHorizontalWeel();
  setFixedColumns();
  checkAssociated();
  toogleConceptInTable();
 });

$(document).on("ready pjax:complete", function() {
  setFileData();
  $index = {};
  populateConfigTableHeader();
})

$(document).on("nested:fieldAdded:attachments", function() {
   $(".attachments").show("fast");
   initializeImageUpload();
})

$(document).on("nested:fieldAdded:budget_attachments", function() {
   $(".attachments").show("fast");
   initializeImageUpload();
})

const setState = (state) => {
  $("#current_state").val(state);
  $("#current_state").closest("form").submit();
}

$(document).on("click", "#sync_state", function(e) {
  syncStates( $(this).data("state") );
  return true;
})

const syncStates = (state) => {
  $("#current_state").val(state);
 }

$(document).on("select2:select", "select#file_select", function() {
  setFileData();
});

const setFileData = () => {
  const element = $("select#file_select");
  const fileType = element.attr("data-type");

  if (element.length && !element.blank() && fileType != null) {
    $.get(`/${fileType}/files/${element.val()}/get_file_data`, null, null, "json")
    .done(function(data) {
      if (data.surgery_end_date != null){
        $("input[id$=expected_delivery_date]").val(data.surgery_end_date)
      }
      if (data.client != null){
        $("select[id$=_entity_id]:not([data-type='supplier'])").val(data.client.id).trigger("change");
        let cbte_tipo = $("select[id$=_cbte_tipo]:not(:disabled)")
        if (cbte_tipo.blank()){
          populateSelect(data.available_cbte_tipo, "select[id$=_cbte_tipo]:not(:disabled)")
        }
      }
      if (data.sale_type != null){$("select[id$=_type]:not([id*=shipment])").val(data.sale_type).trigger("change")}
      setFileModal(data);
      if (data.iva_aliquot != null){
        setDetailsIVA(data.iva_aliquot);
        $("#hidden_iva").val(data.iva_aliquot);
      }
     })
  } else {
    $("select[id^=sale_][id$=_client_id]").val("").trigger("change")
    $("#file_data .modal-body").html("<div class='modal-body'><h5 class='text-center'><i class='fas fa-exclamation-circle'></i> Primero tiene que seleccionar un expediente.</h5></div>")
  }
}

const setFileModal = (data) => {
  var modal = $("#file_data")
  if (modal.length){
    $("#file_data .modal-body").html(`<div class="d-flex">
      <dt class="mx-3 flex-grow-1">Obra social</dt>
      <dd class="mx-3 text-right" style="white-space: normal"><a href="/clients/${data.client.id}">${data.client.name}</a></dd>
    </div>
    <hr class="dotted">
    <div class="d-flex">
      <dt class="mx-3 flex-grow-1">Tipo</dt>
      <dd class="mx-3 text-right" style="white-space: normal">${data.detail}</dd>
    </div>
    <hr class="dotted">
    <div class="d-flex">
      <dt class="mx-3 flex-grow-1">Médico</dt>
      <dd class="mx-3 text-right" style="white-space: normal">${data.doctor}</dd>
    </div>
    <hr class="dotted">
    <div class="d-flex">
      <dt class="mx-3 flex-grow-1">Paciente</dt>
      <dd class="mx-3 text-right" style="white-space: normal">${data.pacient}</dd>
    </div>
    <hr class="dotted">
    <div class="d-flex">
      <dt class="mx-3 flex-grow-1">Provincia</dt>
      <dd class="mx-3 text-right" style="white-space: normal">${data.province}</dd>
    </div>
    <hr class="dotted">
    <div class="d-flex">
      <dt class="mx-3 flex-grow-1">Lugar</dt>
      <dd class="mx-3 text-right" style="white-space: normal">${data.place}</dd>
    </div>
    <hr class="dotted">
    <div class="d-flex">
      <dt class="mx-3 flex-grow-1">Fecha de inicio</dt>
      <dd class="mx-3 text-right" style="white-space: normal">${data.init_date}</dd>
    </div>
    <hr class="dotted">
    <div class="d-flex">
      <dt class="mx-3 flex-grow-1">Fecha de cirugía</dt>
      <dd class="mx-3 text-right" style="white-space: normal">${data.surgery_end_date}</dd>
    </div>
    <hr>
    <center>
      <button name="button" type="button" class="btn btn-secondary text-center" data-dismiss="modal"><i class="fas fa-times"></i> Cerrar</button>
    </center>`)
  }

}


function displaySurgeries(date) {
  $.get("/surgeries/files/for_calendar", {date: date}, null, "html")
  .done(function(data) {
    $(".surgery_general").html(data)
  })
}

function displaySales(date) {
  $.get("/sales/files/for_calendar", {date: date}, null, "html")
  .done(function(data) {
    $(".sale_general").html(data)
  })
}

function displayFiles(date) {
  $.get("/reports/storages/for_calendar", {date: date}, null, "html")
  .done(function(data) {
    $(".sale_general").html(data)
  })
}

$(document).on("change", "input[id$=cbte_fch], input[id*=budget][id$=_init_date], input[id*=order][id$=expected_delivery_date]", function(){
  getDolar($(this).val());
});

function getDolar(date) {
  params = {
    "date" : date
  }
  $.get("/dolar_conversions/dolar_cotization", params, null, "json")
  .done(function(data) {
    $("#parent_usd_price").val(data["dolar_sell"]);
    calculateHeader();
  })
}

$(document).on("click", "#sale_order_details", function(e){
  var saleOrders = $("select[id^=surgeries_shipment_shipments_sale_orders_attributes_][id$=_order_id]:visible").map( (index, object) => $(object).val() )
  if (saleOrders.length == 0 ){
   saleOrders = $("select[id^=agreement_surgeries_shipment_shipments_sale_orders_attributes_][id$=_order_id]:visible").map( (index, object) => $(object).val() )
   $.get("/agreement_surgeries/sale_orders/get_details", {sale_order_ids: saleOrders.toArray()}, null, "script")
  } else{
    $.get("/surgeries/sale_orders/get_details", {sale_order_ids: saleOrders.toArray()}, null, "script")
  }
})

$(document).on("click", "#shipment_details", function(e){
  const shipments = $("select[id^=surgeries_purchase_request_purchase_requests_shipments][id$=_shipment_id]:visible").map( (index, object) => $(object).val() )
  $.get("/surgeries/shipments/get_details", {shipment_ids: shipments.toArray()}, null, "script")
})

$(document).on("click", "button[type=submit]:not(.file_state_submit)", function(event){
  const form = $(this).closest("form");
  const isFileDocument = form.find("#file_select").length > 0
  const purchaseFile = form.attr("action").indexOf("/purchases/") >= 0
  if (isFileDocument && !purchaseFile){
    event.preventDefault();
    $("#file_state").modal("show");
    return false
  }
})
