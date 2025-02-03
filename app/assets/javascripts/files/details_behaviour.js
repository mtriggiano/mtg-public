// Ejecutar metodos al agregar detalle
$(document).on('nested:fieldAdded:details', function(e) {
  number = $(".parent_row_number:visible").length
  recalculateNumbers()

  toogleConceptInTable()
  setDetailsIVA($("#hidden_iva").val());
  calculateHeader();
})

 // Ejecutar metodos al eliminar detalle
$(document).on('nested:fieldRemoved:details', function(e) { //Si eliminamos todos los detalles podemos volver a editar el proveedor.
  removeChilds(e.field)
  calculateHeader();
  setDetailsIVA($("#hidden_iva").val());
  recalculateNumbers()
});

// Ejecutar metodos al agregar hijos del detalle
$(document).on('nested:fieldAdded:childs', function(event) {

  addChildToTable(event)
  toogleConceptInTable()
  setSummernote();
  recalculateNumbers()
})

// Ejecutar metodos al eliminar hijosdetalle
$(document).on('nested:fieldRemoved:childs', function(e) {
  $(e.field).prev("tr[id^=parent_]").checkChildButton()
  recalculateNumbers()
});


// Llama al get detail cuando se selecciona un producto en un detalle
$(document).on("select2:select", "select[id*=details_attributes_][id$=_product_id]", function(e) {
  tr = $(this).closest("tr.fields");
  getDetail(tr, e);
});

const recalculateNumbers = () => {
  $(".parent_row_number:visible").each( (i, input) => {
    if ( $(input).find("input").val() == (i+1) || $(input).find("input").val() == "") {
      $(input).find("input").val((i+1))
    }
    $(input).find("span").html("#" + (i+1))
  })
  childCounter = 1

  $(".child_row_number:visible").each( (i, input) => {
    $(input).find("input").val(childCounter)
    $(input).find("span").html(childCounter)
    if ($(input).closest("tr").next("tr").hasClass("child")){
      childCounter++
    }else{
      childCounter = 1
    }
  })
}

async function getDetail(tr, e){
	const doc = tr.closest("form").attr("document_name")
  var data = e.params.data;
  const file = $("#file_select").data("type")
  if (typeof file != "undefined"){
    tr.find(`.${file}_${doc}_details_product_code > input`).val(data.product_code);
    tr.find(`.${file}_${doc}_details_product_supplier_code > input`).val(data.product_supplier_code);
    tr.find(`.${file}_${doc}_details_branch > input`).val(data.product_branch);
    tr.find(`.${file}_${doc}_details_price > input`).val(data.product_price);
    tr.find(`.${file}_${doc}_details_product_measurement > input`).val(data.product_measurement);
  }else{
    tr.find(`.${doc}_details_product_code > input`).val(data.product_code);
    tr.find(`.${doc}_details_product_supplier_code > input`).val(data.product_supplier_code);
    tr.find(`.${doc}_details_branch > input`).val(data.product_branch);
    tr.find(`.${doc}_details_price > input`).val(data.product_price);
    tr.find(`.${doc}_details_product_measurement > input`).val(data.product_measurement);
  }
  tr.find(`#childs_size`).val(data.childs_size);
  if (data.childs != []){
    tr.find('button.gtin_modal').removeClass("hidden")
  }else{
    tr.find('button.gtin_modal').addClass("hidden")
  }
  var quantity =  tr.find(`.${file}_${doc}_details_quantity > input`)
  if (quantity != null){
    quantity.val(1)
  }
  calculateSubtotalWithIVA(tr);
  getChilds(doc, data, tr, false)
}


async function getChilds(doc, product_data, tr, without_childs=true, page=0){
	const file 				= $("#file_select").data("type");
	const product_id 	= product_data.id;
  const detail_id 	= tr.next(`input:hidden[id^=${file}_${doc}_details_attributes][id$=_id]`).val();
  const supplier_id = $("select[id$=_entity_id]").val();
  const client_id 	= $("select[id$=_client_id]").val();
  const size        = parseFloat(tr.find("input[id$=childs_size]").val());

  if (typeof file != "undefined"){
    url = `/${file}/${doc}s/add_detail`
  }
  else {
    url = `/${doc}s/add_detail`
  }
  if ( page * 50 > size || size == 0 || isNaN(size) ){
    setSelect2();
    //toogleBody();
  }else{
    page++
    $.ajax({
      url: url,
      data: {
        product_id: product_id,
        without_childs: without_childs,
        supplier_id: supplier_id,
        client_id: client_id,
        detail_id: detail_id,
        page,
        index: tr.attr("id").replace("parent_", "")
      },
      dataType: "script",
      async: true
    }).always( function(){
      getChilds(doc, product_data, tr, false, page)
    })
  }
}
//Calcula el encabezado sin tener en cuenta detalles deshabilitados
$(document).on("change", "select[id^=sale_][id*=_details_attributes_][id$=_state]", function() {
   calculateHeader()
 })

// Elimina los datos cargados anteriormente cuando se va a seleccionar un nuevo producto
// $(document).on("select2:open", "select[id*=detail][id$=_product_id]", function() {
//   var tr = $(this).closest("tr.fields");
//   $(this).val("");
//   tr.find("[class$=_product_code] > input").val("");
//   tr.find("[class$=_price] > input").val(0);
// })

//Muestra los detalles si es que tienen un error
//$(document).on("ready", function() {
//  $(".form-group-invalid").closest("tr").prevUntil("tr[id^=parent_]").nextUntil("tr[id^=parent_]").show("fast");
//})

//Especifica si el IVA fue modificado por el usuario
$(document).on("select2:select", "select[id$=_iva_aliquot]", function(){
  $(this).attr("data-modified", true)
})

//Modifica el IVA de todos los detalles que no fueron modificados por el usuario
const setDetailsIVA = (iva_aliquot) => {
  $("select[id*=_details_attributes_][id$=_iva_aliquot]").each(function(){
    if (!$(this).data("modified") && $(this).is(":visible") ) {
      $(this).val(iva_aliquot).trigger("change")
    }
  })
}


// Cambia el tipo de detalle Producto o servicio
$(document).on("select2:select", "select[id$=_detail_type]", function(){
  const tipo = $(this).val()
  const tr = $(this).closest("tr")
  if (tipo == "Servicio"){
    tr.find("select[id$=_product_id]").val(null)
    tr.find("select[id$=_product_id]").closest("div").hide()
    tr.find("input[id$=_product_name]").attr("type", "text")
  }else{
    tr.find("input[id$=_product_name]").val(null)
    tr.find("input[id$=_product_name]").attr("type", "hidden")
    tr.find("select[id$=_product_id]").closest("div").show()
  }
})

$(document).on("select2:select", "select[id*=details_attributes_][id$=_surgery_material_id]", function(e) {
  tr = $(this).closest("tr.fields");
  const doc = tr.closest("form").attr("document_name");
  var data = e.params.data;
  const file = $("#file_select").data("type");
  if (typeof file != "undefined"){
    tr.find(`.${file}_${doc}_details_price > input`).val(parseFloat(data.product_price));
    tr.find(`.${file}_${doc}_details_price > input`).trigger('change');
  }else{
    tr.find(`.${doc}_details_price > input`).val(data.product_price);
    tr.find(`.${doc}_details_price > input`).trigger('change');
  }
});