$(document).on("click", "button.dont_delete", function(){
	$(this).closest("tr").find("input.quantity_td").val(0)
})