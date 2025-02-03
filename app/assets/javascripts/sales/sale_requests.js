// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on("ready pjax:complete", function(){
	checkType()
})

$(document).on("select2:select", "#sale_request_request_type", function(){
	checkType();
})

function checkType(){
	tipo = $("#sale_request_request_type")
	if (tipo.val() == "Cirugía") {
		$("#surgery_data").show("fast")
	}else{
		$("#surgery_data").hide("fast")
	}
}