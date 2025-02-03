$.fn.checkChildButton = function(){
  var button = $(this).find(".child_button");
  const have_child = $(this).next("tr:visible").hasClass("child");
  if (have_child) {
    button.removeClass("disabled")
  }else{
    if (!button.hasClass("disabled")){ button.addClass('disabled') }
  }
}


const toogleConceptInTable = () => {
	getHiddenHeaders()
  $("table.parent-table tr:not([id$=observation]) td").each( function(j, i){
    $(this).removeClass("hidden")
  })
 	$.each($index, function(j, i) {
   	$("table.parent-table > tbody > tr:not([id$=observation])").each(function() {
     		if (i == "hide") {
       		$(this).find('td').eq(j).addClass("hidden")
     		}
   	})
   	})
 }

const getHiddenHeaders = () => {
  $index = {}

	$("th.hidden").each(function() {
 		$index[$(this).index()] = "hide"
	})
}

const addChildToTable = (e) => {
   	const tr_detail = $(e.target.parentElement) //$(`tr#${parent_id}`)
 	  const tr_child 	= $(e.target);
   	const parent_id = e.target.parentElement.id

   	displayChilds(tr_detail)
   	tr_child.insertAfter(tr_detail);
   	tr_child.attr("style", "display: table-row;");
    tr_detail.checkChildButton()
    tr_detail.nextUntil("tr[id^=parent_]:not([id$='_observation'])").filter("tr:visible[id^=child_]").each( (index, child) => {
      number = index + 1
      $(child).find(".child_row_number input").val(number)
      $(child).find(".child_row_number span").text("#" + number)
    })
}

// Cuando un detalle padre tiene asociado varios hijos, esta funcion los muestra debajo del padre.
const displayChilds = (tr) => {
 	tr.nextUntil("tr[id^=parent_]:not([id$='_observation'])").filter("tr[id^=child_]").each(function() {
    if ( $(this).find("input[id$=__destroy]").val() != "1" ){
      $(this).show("fast");
    }
  })
}

const toggleChilds = (tr) => {
  const button_disabled = tr.find(".child_button").hasClass("disabled");
  if (!button_disabled) {
    tr.nextUntil("tr[id^=parent_]:not([id$='_observation'])").filter("tr[id^=child_]").each(function() {
      if ( $(this).find("input[id$=__destroy]").val() != "1" ){
        $(this).toggle("fast");
      }
    })
  }
}

// Elimina todos los hijos de un detalle.
const removeChilds = (tr) => {

   	$(tr).nextUntil("tr:not([id^=child_])").each(function() {
     	$(this).find("a.remove_nested_fields").click();
      $(this).find(".modal").remove()
   	})
   	const observation = $(`tr#${tr.attr("id")}_observation`);

   	if (observation.length) {
     	observation.collapse('hide')
   	}
}

const populateConfigTableHeader = () => {
  	var table = $("table.parent-table");
  	var dropdown_menu = $(".display-th").find(".dropdown-menu");

  	dropdown_menu.html("");

  	table.find("th:not(.important)").each(function() {
	    th_text = $(this).text().trim()
	    action = `toggleConcept('${th_text}')`
	    if ($(this).hasClass("hidden")) {
	     	text_with_icon = '<i class="fas fa-times"></i> ' + th_text
	    } else {
	     	text_with_icon = th_text
	    }
    	dropdown_menu.append(`<button class="dropdown-item" type="button" onclick="${action}">${text_with_icon}</button>`);
  	})
}

const toggleConcept = (text) => {
   	getHiddenHeaders();

   	const current_index = $('th:contains("' + text + '")').index();

   	if ($index[current_index] == "hide") {
		$index[current_index] = "show";
		$("table.parent-table > thead > tr").find('th').eq(current_index).removeClass("hidden");

		$.ajax({
			type: "POST",
			url: "/user_table_configs",
			data: {
		 		"attribute": text,
		 		"table": $("#toggleConceptsButton").data("for"),
		 		"_destroy": true
			}
		})
		$('button.dropdown-item:contains("' + text + '")').html(text)

   	}else{
	    $index[current_index] = "hide"
		$('button.dropdown-item:contains("' + text + '")').html('<i class="fas fa-times"></i>' + text)
		$("table.parent-table > thead > tr").find('th').eq(current_index).addClass("hidden")
		$.ajax({
			type: "POST",
			url: "/user_table_configs",
			data: {
		 		"attribute": text,
		 		"table": $("#toggleConceptsButton").data("for")
			}
		})
   	}
   	toogleConceptInTable($index)
}

//Setea el ancho de las columnas fixeadas
const setFixedColumns = () => {
  const outerW = $("td.fixed-col").closest("tr").find(".fixed-col:last").outerWidth()
  $(".fixed-col").each(function() {
    if (!$(this).is(":last-child")) {
      $(this).css({ "right": outerW });
    }
  })
}

//Setea el scroll horizontal
const setHorizontalWeel = () => {
  $(".table-responsive:not(.index-body)").mousewheel(function(event, delta) {
    this.scrollLeft -= (delta * 60);
  });
}
