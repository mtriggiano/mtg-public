$(document).on("select2:select", "select[id*=_shipment_details_attributes][id$=_product_id]", function(e){
	tr = $(this).closest("tr");
	var data = e.params.data;
	setBatchesFromProduct(tr, data)
})

$(document).on("select2:select", "select[id^=sale_shipment_details_attributes][id$=_batch_id]", function(){
	tr = $(this).closest("tr");
	batch_id = $(this).val()
	setGtinsFromBatch(tr, batch_id)
})

function setShipmentState(state){

	$("#current_state").val(state)

	$("#current_state").closest("form").submit()
}

function sendShipmentPDF(id){
	$.get("/sale_shipments/" + id + "/deliver", {email: $("#email").val()}, null, "html")
		.done(function(response){
			$("body").html(response)
		})
}

$(document).on("select2:select", "[id$=product_gtin]" , function(){
	let selected_values = $(this).val();
	select = $(this)
	$.each(selected_values, function(index, value){
		select.find(`[value=${value}]`).addClass('disabled')
	})
	select.select2();
})
