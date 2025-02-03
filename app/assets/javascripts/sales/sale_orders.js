function syncTypes(e){
	var response = confirm("Esto cambiara el tipo de todos los detalles asociados al documento. ¿Está seguro que desea continuar?")
	if (response) {
	  	type = $("#current_type").val();
	  	$("select[id^=sale_][id*=_details_attributes_][id$=_detail_type]").each(function(){
	    	$(this).val(type).trigger('change');
	  	})
	  	$("#current_type").closest("form").submit();
	}
}

$(document).on("select2:select", ".user_ov_comisionant", function(){
	selected_value = $(this).val()
	setComissionantInOrders(selected_value);
})

$(document).on("nested:fieldAdded:details", function(e) {
	if ( $("#klass_validator").val() == "Surgeries::SaleOrder" || $("#klass_validator").val() == "Sales::Order" )
	{
		selected = $("#general_user_selected").val()
		if (selected == "") {
			primer_detalle = $(document).find('.fields:visible').find(".user_ov_comisionant").first().val()
			e.field.find(".user_ov_comisionant").val(primer_detalle).trigger("change")
		}
		else {
			e.field.find(".user_ov_comisionant").val($("#general_user_selected").val()).trigger("change")
		}
	}


})

function setComissionantInOrders (selected) {
	// all_user_id_visibles = $(".user_ov_comisionant")
	// all_user_id_visibles.each(function() {
	// 	$(this).val(selected_value).trigger("change");
	// });
	$("#general_user_selected").val(selected_value);
}
