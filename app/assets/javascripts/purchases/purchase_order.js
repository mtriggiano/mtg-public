$(document).on("focusout", "#purchase_order_shipping_price", function(){
	if ($(this).val() == "") {
		$(this).val(0).trigger("change")
	}
})