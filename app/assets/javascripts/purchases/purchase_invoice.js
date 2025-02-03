$(document).on("select2:select", "#new_associated_document", function(){
	$.get("/purchase_invoices/add_detail", {purchase_arrival_id: $(this).val()}, null, "script")
})

$(document).on("select2:select", "#surgeries_supplier_bill_entity_id", function(){
	let form 		= $(this).closest("form");
	let method 		= form.find("input[name=_method]").val();
	let url 		= form.attr("action");
	let supplier_id = $(this).val();

    if (method == "" || method == "patch" ) {
      url = url + "/edit"
    }else if(method == null){
      url = url + "/new";
    }else{
      url = url + "/new"
    }
	$.get(url, {surgeries_supplier_bill: {entity_id: supplier_id}}, null, "script")
})
