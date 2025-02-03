/*$(document).on("click", ".gtins-popover", function(){
	setGtinPopover(this);
})

function setGtinPopover(element){
	let td = $(element).closest("td");
	let gtins = td.find(".gtins-body");
	$(element).popover({
    	container: td,
    	trigger: 'click',
    	html: true,
        content: function(){
        	return td.find(".gtins-body").html();
        }
    })

    $(element).popover("show")
    $($(element).data("bs.popover").tip).addClass("popover-height");
}

function closeGtinPopover(button){
    td = $(button).closest("td");
    let gtins = td.find(".popover").find(".popover-body").html();
    $(button).closest(".popover").popover("hide").popover("dispose");
    td.find(".gtins-body").html(gtins)
}

$(document).on("keyup", ".gtin-input", function(){
	$(this).attr("value", $(this).val())
})
*/

$(document).on('keydown', '.gtin-input', function(e) {
  var code = (e.keyCode ? e.keyCode : e.which);
  if (code == 9) {
    $(this).closest("td").find('a.add_nested_fields[data-association="gtins"]').click();
    return false;
  }
});

$(document).on('nested:fieldAdded:gtins', function(e){
    e.field.find("input.gtin-input").focus();
})

$(document).on('click', 'a.remove_nested_fields[data-association="gtins"]', function(e){
    var fields_count = $(this).closest("td").find(".fields:visible").length
    if (fields_count == 0) {
       $(this).closest("td").find('a.add_nested_fields[data-association="gtins"]').click()
    }
})
