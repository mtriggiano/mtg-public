$(document).on("select2:select", "select[id$=shipment_from], select[id$=shipment_to]", function(){
	$("select[id$=shipment_id_evento").val("").trigger("change")
	checkEventSelect();
})

$(document).on("ready pjax:complete", function(){
	checkEventSelect();
	checkRequestStockButton();
})

function checkEventSelect(){
	const from 	= $("select[id$=shipment_from]");
	const to 	= $("select[id$=shipment_to]");
	if (from.length && to.length){
		if (from.blank() || to.blank()){
			$("select[id$=shipment_id_evento").attr("disabled", true)
		}else{
			$("select[id$=shipment_id_evento").attr("disabled", false)
		}
	}
}

$(document).on('nested:fieldAdded', function(event) {
	checkRequestStockButton();
	$("input[id^=surgeries_shipment_details_attributes][id$=_quantity]").trigger("change")
})


function checkRequestStockButton(){
	var result = []
	var button = $("button[name=request_stock]")
	var confirmButton = $("button[data-target='#edit_shipment']")
	result = $('.stock-rounded').map( (index, object) => {
		const tr = $(object).closest("tr");
		const destroyed = tr.find("input[id$=_destroy]").val()
        if (destroyed == "false"){ 
			return $(object).hasClass("bg-danger")
		}
	})

	if ($.inArray(true, result) != -1){
		button.removeClass("hidden")
		confirmButton.addClass("hidden")
	}else{
		button.addClass("hidden")
		confirmButton.removeClass("hidden")
	}
}

function checkStockState(quantity){
	const product_id = quantity.closest("tr").find("select[id$=_product_id]").val()
	const needed_quantity = quantity.val();
	if (product_id != null && product_id != "" && needed_quantity != null){
		$.get(`/inventaries/${product_id}/stock`, {}, null, "json")
		.done( data => {
			if (data >= needed_quantity){
				quantity.closest("tr").find(".stock-rounded").attr("class", "stock-rounded bg-success").attr("data-original-title", "Stock disponible");
			}else{
				quantity.closest("tr").find(".stock-rounded").attr("class", "stock-rounded bg-danger").attr("data-original-title", "Stock insuficiente");
			}
		}).done( () =>{
				checkRequestStockButton()
			}
		)
	}
}

$(document).on("change", "input[id^=surgeries_shipment_details_attributes_][id$=_quantity]:visible", function() {
	checkStockState( $(this) );
});