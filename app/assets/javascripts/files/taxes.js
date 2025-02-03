$(document).on("change", "input[id^=expedient_receipt_taxes_attributes_][id$=_total]", function(){
	calculateTotal();
})