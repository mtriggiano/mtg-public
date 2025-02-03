function populateBatch(data, batch_id) {
	populateSelect(data, "#" + batch_id);
	var batch = $("#" + batch_id)
	batch.removeAttr("disabled").removeClass("disabled")
	populateGtins(batch)
}

function setBatchFromProduct(tr, data) {
   	var batch_select = tr.find("select[id$=_batch_id]")
   	if (data.batches.length !== 0) {
     	populateSelect(data.batches, `#batch_select.attr("id")`);
     	batch_select.prepend("<option value='' selected='selected'>Seleccione...</option>");
   	}else{
     	batch_select.html("<option value='' selected='selected'>Sin stock...</option>");
   	}
   	batch_select.removeAttr("disabled")
}



function showBatchModal(modal_id){
  var data = $(modal_id)
  //data.find('table').unwrap('div.fields')
  data.find('form.to_remove').find('[name=authenticity_token]').remove()
  data.find('form.to_remove').find('[name=utf8]').remove()
  var table = data.find('table.table')
  while (data.find('table.table').closest("form.to_remove").length >= 1){
    table.unwrap()
  }
  
  data.modal("show")
}