function setBatchesFromProduct(tr, data) {
   	product_id = tr.find("select[id*=_shipment_details_attributes_][id$=_batch_ids]");
   	if (typeof data.batches != "undefined" && data.batches.length !== 0) {
     	populateSelect(data.batches, "#" + product_id.attr("id"));
   	}
   	product_id.removeAttr("disabled")
   tr.find("input[id$=_product_code]").val(data.product_code)
}

function populateGtins(batch) {
	const batch_id = batch.val();
	const product_id = $(batch).closest("tr").find("select[id$=_product_id]").val();
	const gtin = $(batch).closest("tr").find("select[id$=gtin_ids]");

	$.get(`/products/${product_id}/batches/${batch_id}/unit_gtins`, { state: true }, null, "json")
	.done(function(data) {
	 	populateSelect(data, `#${gtin.attr("id")}`);
	 	gtin.removeAttr("disabled")
	 	setSelect2()
	})

}