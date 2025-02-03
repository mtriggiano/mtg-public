$(document).on("select2:select", "select[id^=purchase_return_details_attributes][id$=_product_id]", function(e){
	tr = $(this).closest("tr");
	var data = e.params.data;
	setBatchFromProduct(tr, data)
})

/*$(document).on("select2:select", "select[id^=purchase_return_details_attributes][id$=_batch_id]", function(){
	tr = $(this).closest("tr");
	batch_id = $(this).val()
	setGtinsFromBatch(tr, batch_id)
})*/