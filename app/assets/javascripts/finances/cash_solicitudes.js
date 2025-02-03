$(document).on("nested:fieldRemoved", function(event) {
  calculateRefundTotal()
})

$(document).on("ready ajaxComplete pjax:complete", () => {
  calculateRefundTotal()
})

// Sirve para ocultar o mostrar el campo de Motivo de Rechazo al evaluar una solicitud de fondos
// Se inicializa desde la vista
function toggleRejectEvaluationReason() {
  if ($(".evaluation_toggle").is(":checked")) {
      $(".reject_reason label, .reject_reason textarea").hide();
      $(".reject_reason textarea").removeAttr('required').attr('disabled', 'disabled');
      $(".reject_reason").addClass('hidden');

      $(".approved_amount label, .approved_amount input").show();
      $(".approved_amount input").attr('required','required').removeAttr('disabled');
      $(".approved_amount").removeClass('hidden');
		}
		else {
      $(".approved_amount label, .approved_amount input").hide();
      $(".approved_amount input").removeAttr('required').attr('disabled', 'disabled');
      $(".approved_amount").addClass('hidden');

      $(".reject_reason label, .reject_reason textarea").show();
			$(".reject_reason textarea").attr('required','required').removeAttr('disabled');
      $(".reject_reason").removeClass('hidden');
		}
}

// calcula el monto a rendir cuando registramos los gastos de una solicitud de fondos
function calculateRefundTotal() {
  acc = parseFloat(0)
  $('.expense-bill-total').filter(':visible').each((index, el) => {
    if ($(el).val()) { acc += parseFloat($(el).val())  }
  })
  $('.expenses-total').text(acc.toFixed(2))
  retiro = parseFloat($('.withdrawal-total').first().text())
  $('.refund-total').text((retiro - acc).toFixed(2))
  $('#cash_solicitude_cash_refund_attributes_importe').val((retiro - acc).toFixed(2))
}
