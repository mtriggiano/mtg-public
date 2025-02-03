$(document).on("change", ".document-input", function(){
	var that = $(this)
	$(this).addClass("document-input-loading");
	$.get("/get_padron", {data: $(this).val()}, null, "json")
	.done(function(data){
		if (data != null) {
			$(".autocomplete-name").val(data.name);
			$(".autocomplete-address").val(data.address);
			$(".autocomplete-cp").val(data.cp);
		}
		that.removeClass("document-input-loading");
	})
})