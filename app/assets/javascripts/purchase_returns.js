// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(document).on("select2:select", "select[id^=purchase_returns_details_attributes_][id$=_product_id]", function(e){
  var data = e.params.data;
  $(this).closest("tr.fields").find(".purchase_order_details_product_supplier_code > input").val(data.supplier_code);
});


$(document).on("select2:select", "select[id^=purchase_return_purchase_return_orders_attributes_][id$=_purchase_order_id]", function(){
  getDetails("return", "order")
})


$(document).on('nested:fieldRemoved:purchase_return_orders', function(){
  getDetails("return", "order")
})
