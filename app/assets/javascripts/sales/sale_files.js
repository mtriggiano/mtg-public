$(document).on("select2:select", "#sale_file_sale_type", function(){
	setSaleFileLabel()
})

$(document).on("ajaxComplete", function(){
	setSaleFileLabel()
})

function setSaleFileLabel(){
	if ($("#sale_file_sale_type").val() == "Cirugía") {
		$("label[for='sale_file_finish_date']").html("Fecha de cirugía");
	}else{
		$("label[for='sale_file_finish_date']").html("Fecha límite de finalización");
	}
}

$(document).on("keyup", "[id^='sale_file_client_attributes_']", function(){
	$("#sale_file_client_id").val("").trigger("change")
})

$(document).on("select2:select", "#sale_file_client_id", function(){
	$(".client_form").hide("slow");
})


$(document).on("ready pjax:complete", function(){
    let wrapper = $("td.product_description");
    let options = {
      after: 'a.more',
      truncate: "word",
      watch: true,
      height: 100
    };
    if (wrapper.length){
      wrapper.dotdotdot(options);
    }
});


$(document).on("click", "a.less", function(){
	let wrapper = $(this).closest("td.product_description");
    let options = {
      after: 'a.more',
      truncate: "word",
      watch: true,
      height: 100,
      callback: function(){$(this).find("a.less").hide()}
    };

   if (wrapper.length){
      wrapper.dotdotdot(options);
    }
})

$(document).on("click", "a.more", function(){
	let wrapper = $(this).closest("td.product_description");
    let options = {
      after: 'a.more',
      truncate: "word",
      watch: true,
      height: null,
      callback: function(){$(this).find("a.more").hide()}
    };

   if (wrapper.length){
      wrapper.dotdotdot(options);
    }
})