$(document).on('nested:fieldAdded:details', function(e){
  var store_id = $("select#transfer_note_store_id").val();
  if (store_id != null){
    if (store_id.length != 0) {
      var field   	= e.field;
      detail_line 	= field.find("select[id^=transfer_note_details_attributes_][id$=_store_line_id]");
      detail_line.attr("data-url", "/stores/externals/" + store_id + "/available_store_lines"); //agregamos el url a consultar por select2 para traer solo productos del proveedor seleccionado.
      setSelect2() // Establecemos el comportamiento del select
      //disabledSupplierSelect(); //Desabilitamos el cambio del proveedor siempre y cuando existan detalles.
    }
    //checkLinktoAdd();
  }
});