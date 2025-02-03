$.fn.changeChildrensApprovedQuantity = function(req_quantity, current) {
  $(this).each(function() {
    var current_value = $(this).find("input[id*=_details_attributes_][id*=_childs_attributes_][id$=_quantity]").val();
    if (current_value != null) {
      var new_value = parseFloat(current_value) / parseFloat(req_quantity) * parseFloat(current);
      $(this).find("input[id*=_details_attributes_][id*=_childs_attributes_][id$=_approved_quantity]").val(new_value.toFixed(2));
    }
    if (current_value == 0) {
      $(this).find("input[id*=_details_attributes_][id*=_childs_attributes_][id$=_approved_quantity]").val(0);
    }
  })
}

$.fn.changeChildrensQuantity = function(prev, current) {
  $(this).each(function() {
    current_value = $(this).find("input[id*=_details_attributes_][id*=_childs_attributes_][id$=_quantity]:not([id*=approved])").val();
    new_value = current_value / prev * current
    $(this).find("input[id*=_details_attributes_][id*=_childs_attributes_][id$=_quantity]:not([id*=approved])").val(new_value.toFixed(2)).trigger("change");
  })
}

// $(document).on('focusin', 'input[id*=_details_attributes_][id$=_quantity]:not([id*=approved],[id*=_childs_attributes_])', function() {
//   value = $(this).val()
//   if (value != 0) {
//     $(this).attr('data-val', value);
//   }
// }).on('keyup', '[id*=_details_attributes_][id$=_quantity]:not([id*=approved],[id*=_childs_attributes_])', function() {
//   value = $(this).val()
//   if (value != 0) {
//     var prev = $(this).attr('data-val') || 1;
//     var current = $(this).val();
//     var parent = $(this).closest("tr");
//     $(this).attr('data-val', current);
//     parent.nextUntil("tr[id^=parent_]", "tr").changeChildrensQuantity(prev, current);
//   }
// });

// $(document).on('focusin', '[id*=_details_attributes_][id$=_approved_quantity]:not([id*=_childs_attributes_])', function() {
//   value = $(this).val()
//   if (value != 0) {
//     $(this).attr('data-val', value);
//   }
// }).on('keyup', '[id*=_details_attributes_][id$=_approved_quantity]:not([id*=_childs_attributes_])', function() {
//   value = $(this).val()
//
//   if (value != 0) {
//     var req_quantity = $(this).closest("tr").find("[id*=_details_attributes_][id$=_quantity]").val();
//     var current = $(this).val();
//     var parent = $(this).closest("tr");
//     $(this).attr('data-val', current);
//     parent.nextUntil("tr[id^=parent_]", "tr").changeChildrensApprovedQuantity(req_quantity, current);
//   }
// });

$(document).on("select2:select", "select[id*=details][id$=product_id]", function(){
  const box   = $(this);
  const tr    = box.closest("tr")
  const tr_id = tr.attr("id").replace("parent_", "")
  childs      = $(`.child_${tr_id}`)
  childs.each(function(){
    const child_tr = $(this).closest("tr")
    child_tr.find(".remove_nested_fields").click()
  })
})
