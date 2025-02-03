function sendBudgetPDF(id, parent){

	$.get(`/${parent}/${id}/deliver`, {email: $("#send_email_tag").val()}, null, "html")
		.done(function(response){
			$("body").html(response)
		})
}
