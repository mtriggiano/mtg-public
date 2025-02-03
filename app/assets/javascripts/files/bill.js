$(document).on("change", "select[id*=bill][id$=_subtype]", function(){
	changeDetailType($(this));
	checkConcept();
	checkDynamicAttributes();
});

$(document).on("select2:select", "select[id*=bill][id$=_concept]", function(){
	checkDynamicAttributes();
})

$(document).on("ready pjax:complete ajaxComplete nested:fieldRemoved:details nested:fieldAdded:details", function(){

		if ($("#klass_validator").val() == "Sales::Bill" || $("#klass_validator").val() == "Surgeries::ClientBill" || $("#klass_validator").val() == "Surgeries::SupplierBill" || $("#klass_validator").val() == "ExternalBill" || $("#klass_validator").val() == "Tenders::Bill")
		{
			$.each( $("select[id*=bill][id$=_subtype]"), function(i, o){
				changeDetailType($(o));
			})
			checkConcept();
			checkAssociatedBill();
			checkDynamicAttributes();
		}
})

$(document).on("select2:select", "select[id$=_bill_manual]", function(){
	const manual = $(this).val();
	const form = $(this).closest("form")
	const action = form.attr("action")
	if (form.attr('document_id') == ''){
		$("input[id$=bill_number]").attr("disabled", manual == "E")
	}else{
		$.get(`${action}/set_manual`, {manual}, null, "script")
	}
})

const changeDetailType = (detail) =>{
	const tr = detail.closest("tr");
	const type = detail.val() == "Sales::BillInventary" ||
		detail.val() == "Purchases::BillInventary"  ||
		detail.val() == "Tenders::BillInventary" ?
			"product" :
			"service"
	if (type == "product"){
		tr.find("div[class*=bill_details_product_id]").show()
		tr.find("[id$=_product_name]").attr("type", "hidden").val("")
	}else{
		tr.find("div[class*=bill_details_product_id]").hide()
		tr.find("[id$=_product_name]").attr("type", "text")
		tr.find("[id$=_product_id]").val("").trigger("change")
	}
}

$(document).on("select2:select", "#surgeries_client_bill_cbte_tipo, #sales_bill_cbte_tipo, #tenders_bill_cbte_tipo", function(){
	checkAssociatedBill()
	checkConcept()
})

const checkDynamicAttributes = () => {

}

const checkConcept = () => {
	var types = $("select[id*=bill][id$=_subtype]");
	var arr = [];
	$.each(types, function(i, obj){
		const text = $(obj).find("option:selected").text()
		if (text != ""){
			var found = jQuery.inArray(`${text}s`, arr);
			if (found == -1) {
			    arr.push(`${text}s`);
			}

		}
	})
	const text = arr.sort().join(" y ")
	$("select[id$='_concept']").val(text).trigger("change")
}

const checkAssociatedBill = () => {
	const cbte_tipo = $("[id$=bill_cbte_tipo]").val();
	const notes = ["02", "03", "07", "08", "12", "13", "202", "203"]
	const state = $("#current_state").val()
	editable = state == "Pendiente"
	if ($.inArray(cbte_tipo, notes) != -1){
		if (editable) {
			$("[id$=_bill_parent_bill]").removeAttr("disabled")
		} else {
			$("[id$=_bill_parent_bill]").attr("disabled", true)
		}
	}else{
		$("[id$=_bill_parent_bill]").attr("disabled", true)
		$("[id$=_bill_parent_bill]").val(null).trigger("change");
	}
}

$(document).on("select2:select", "select[id$=parent_bill]", function(){
	const bill = $(this).val();
	const form = $(this).closest("form")
	const bill_id = form.attr("document_id")
	const fileType = $("#file_select").data("type");
	if (bill_id != ""){
		if (fileType == "surgeries"){
			$.get(`/${fileType}/client_bills/associate_document`, {bill: bill}, null, "script")
		}else{
			$.get(`/${fileType}/bills/associate_document`, {bill: bill}, null, "script")
		}
	}else{
		if (fileType == "surgeries"){
			$.get(`/${fileType}/client_bills/associate_document`, {bill: bill}, null, "script");
		}else{
			$.get(`/${fileType}/bills/associate_document`, {bill: bill}, null, "script");
		}
	}
})

$(document).on('change', '[id$=_bill_number]', function(){
 	$(this).val($(this).val().padStart(8,'0'));
 })

 $(document).on('change', '[id$=_bill_sale_point]', function(){
 	$(this).val($(this).val().padStart(4,'0'));
 })

 $(document).on('change', 'select[id$=_bill_manual]', function(){
	 const manual = $(this).val() == "M"
	 $('[id$=bill_cbte_fch]').attr('disabled', !manual)
 })
