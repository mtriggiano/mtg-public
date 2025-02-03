$(document).on("change", "#sale_bill_cbte_tipo", function(){
	toggleParentBill( $(this).val() )
})

function toggleParentBill(cbte_tipo){
	state = $("#sale_bill_state").val()
	editable = state == "Pendiente"
	if ($.inArray(cbte_tipo, ["03", "06", "11"]) && editable) {
		$("#sale_bill_parent_bill").prop("disabled", false);
	}else{
		$("#sale_bill_parent_bill").prop("disabled", true);
	}
}

$(document).on("click", "#confirm_invoice_button", function(e){
	e.preventDefault;
	console.log("")
	setBillState($(this).data('state'))
})

function setBillState(state){
	$("#current_state").val(state)
	$("#current_state").closest("form").submit()
}

// $(document).on("change", "#sale_bill_sale_order_id", function(){
// 	$.get("/sale_bills/add_detail", {sale_order_id: $(this).val()}, null, "script")
// })

$(document).on("change", "#sale_bill_sale_file_id", function(){
	$("#sale_bill_sale_order_id").val("").trigger("change")
})

$(document).on("select2:select", "select[id^=sale_bill_details_attributes_][id$=_product_id]", function(e){
	tr = $(this).closest("tr.fields")
    getSaleBillDetail(tr, "bill", e)
})

function getSaleBillDetail(tr, doc, e){
	var data = e.params.data;
	tr.find(".sale_" + doc + "_details_product_code > input").val(data.product_code);
	tr.find(".sale_" + doc + "_details_price > input").val(data.product_price);
	tr.find(".sale_" + doc + "_details_product_measurement > input").val(data.product_measurement);
	tr.find(".sale_" + doc + "_details_discount > input").val(-data.recharge);
	calculateSubtotal(tr);
}
