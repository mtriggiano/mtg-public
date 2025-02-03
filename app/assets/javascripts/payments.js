function getPaymentRequest(url, data, action) {
  $.ajax({
    url: url,
    data: data ,
    contentType: "application/html",
    dataType: "html"
  }).done(function(response) {
    $("#payment_form").html(response)
		$('.datepicker').datepicker({
	      language: "es",
	      dateFormat: "dd/mm/yyyy",
	      todayHighlight: true,
	      autoclose: true,
	      startView: 2
	  });
  });
}
