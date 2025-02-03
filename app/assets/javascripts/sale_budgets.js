$(document).on("select2:select", "select[id^=sale_budget_details_attributes_][id$=_product_id]", function(e){
  var data = e.params.data;
  $(this).closest("tr.fields").find(".sale_budget_details_product_code > input").val(data.product_code);
  $(this).closest("tr.fields").find(".sale_budget_details_price > input").val(data.product_price);
});

$(document).on("select2:open", "select[id^=sale_budget_details_attributes_][id$=_product_id]", function(){
  $(this).val("")
  $(this).closest("tr.fields").find(".sale_budget_details_product_code > input").val("");
  $(this).closest("tr.fields").find(".sale_budget_details_price > input").val("0.0");
})


/*$(document).on("select2:select", "select[id^=sale_budget_sale_budget_requests_attributes_][id$=_sale_request_id]", function(){
  getDetails("budget", "request")
})


$(document).on('nested:fieldRemoved:sale_budget_requests', function(){ 
  getDetails("budget", "request")
})*/

function getBudgetDetails(){
  var params = {sale_requests_ids: { "true": [], "false": []}}
  $("select[id$=_sale_request_id][id^=sale_budget_sale_budget_requests_attributes_]").each(function(){
    params["sale_requests_ids"][$(this).is(":visible")].push($(this).val())
  })
  $.get(window.location.href, params, null, "script")
};