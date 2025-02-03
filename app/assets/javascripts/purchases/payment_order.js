const compNC = ["03", "08", "13", "203", "208", "213"]
const compFyND = ["01", "06", "11", "201", "206", "211", "02", "07", "12", "202", "207", "212"]


$(document).on("change", ".suma-pagos", () => { refreshTotalPaid() })

$(document).on("nested:fieldRemoved:payments nested:fieldRemoved:taxes pjax:complete ready", () => { refreshTotalPaid() })

$(document).on("nested:fieldAdded:payments pjax:complete ready", () => { checkPaymentsAttrsByCollectType() })

$(document).on("select2:select", "select[id^=purchases_payment_order_payments_attributes][id$=_payment_type_id]", () => {	checkPaymentsAttrsByCollectType() })

$(document).on("select2:select", "select[id^=purchases_payment_order_details_attributes][id$=_bill_id]", (e) => {
	var data = e.params.data;
	console.table(data)

	if (compNC.includes(data.tipo_comprobante)) {
		if (parseFloat(data.total_left) < 0) {
			total_left = parseFloat(data.total_left)
		}
		else
		{
			total_left = parseFloat(-data.total_left)
		}
		$(e.currentTarget).closest(".fields").find("input[id$=_total_left]").data("original", total_left)
		$(e.currentTarget).closest(".fields").find("input[id$=_previous_debt]").val(total_left)
		$(e.currentTarget).closest(".fields").find("input[id$=_total]").val(total_left)
	} else {
		$(e.currentTarget).closest(".fields").find("input[id$=_total_left]").data("original", data.total_left)
		$(e.currentTarget).closest(".fields").find("input[id$=_previous_debt]").val(data.total_left)
		$(e.currentTarget).closest(".fields").find("input[id$=_total]").val(data.total_left)
	}

	refreshPaymentOrder(data.id)
	refreshPaymentOrderParentTotal();
})

$(document).on("nested:fieldRemoved:details", function(e) {
	refreshPaymentOrderParentTotal();
})

$(document).on("focus", "input[id^=purchases_payment_order_details_attributes][id$=total]", function(){
	$(this).data("previous",$(this).val());
}).on("change", "input[id^=purchases_payment_order_details_attributes][id$=total]", function() {
	bill_id = $(this).closest(".fields").find("select[id$=bill_id]").val();
	refreshPaymentOrder(bill_id)
})

const refreshPaymentOrder = invoiceId => {
	// actualiza el saldo a partir del Total a pagar

	let total_pagado 	= getTotalPaidFor(invoiceId);
	let a_total_left 	= billTotalLeft(invoiceId)
	let total_left 			= a_total_left - total_pagado
	console.log(a_total_left)
	console.log(total_pagado)
	console.log(total_left)
	refreshTotalLeft(invoiceId, total_left);
}

function getTotalPaidFor(bill_id) {
	var total = 0
	var selectedBill = $(`select:visible[id$=_bill_id] option:selected[value=${bill_id}]`)
	selectedBill.each((e, element) =>{
		let sumTotal = $(element).closest(".fields").find("input[id$=_total]").val();
		total += parseFloat(sumTotal);
	})
	return Math.round10(total)
}

const billTotalLeft = (id) => {
	saldo = $(`select:visible[id$=_bill_id] option:selected[value=${id}]`)
		.closest(".fields").find("[id$=_total_left]").data("original")
	console.log(saldo)
	return Math.round10(saldo)
}

function refreshTotalLeft(bill_id, total_left) {
	$(`select:visible[id$=_bill_id] option:selected[value=${bill_id}]`).each( (e, element) => {
		$(element).closest(".fields").find("input[id$=total_left]").val(total_left.toFixed(2))
	})
}

function refreshTotalPaid() {
	totalPagado = 0
	$('.suma-pagos:visible').each( (e, element) => {
		if ($(element).val()) {
			totalPagado += parseFloat($(element).val())
		}
	})
	$('#total_pagos').val( Math.round10(totalPagado) )
	return Math.round10(totalPagado)
}

function refreshPaymentOrderParentTotal() {
	calculateHeader() // price_calculator.js
}

function checkPaymentsAttrsByCollectType() {
	$('select.payment_type').each( function() {
		let opcionSeleccionada = $(this).find('option:selected')
		let fieldPadre = $(this).closest('.fields')
		let tipoPago = $(opcionSeleccionada).data("collect-type")

		fieldPadre.find(".cuenta-bancaria").attr("disabled", "true");
		fieldPadre.find(".real-date").attr("disabled", "true");
		fieldPadre.find(".numero-referencia").attr("disabled", "true");
		fieldPadre.find(".chequera").attr("disabled", "true");
		fieldPadre.find(".vencimiento-pago").attr("disabled", "true");

		switch (tipoPago) {
			case "Transferencia bancaria":
				fieldPadre.find(".cuenta-bancaria").removeAttr("disabled")
				fieldPadre.find(".real-date").removeAttr("disabled")
				fieldPadre.find(".numero-referencia").removeAttr("disabled")
				fieldPadre.find(".vencimiento-pago").removeAttr("disabled")
				break;
			case "Cheque":
				fieldPadre.find(".numero-referencia").removeAttr("disabled");
				fieldPadre.find(".chequera").removeAttr("disabled");
				fieldPadre.find(".vencimiento-pago").removeAttr("disabled");
				break;
			case "Cheque electrónico":
				fieldPadre.find(".cuenta-bancaria").removeAttr("disabled");
				fieldPadre.find(".real-date").removeAttr("disabled");
				fieldPadre.find(".numero-referencia").removeAttr("disabled");
				fieldPadre.find(".vencimiento-pago").removeAttr("disabled");
				break;
			case "Pagaré":
				fieldPadre.find(".numero-referencia").removeAttr("disabled");
				fieldPadre.find(".vencimiento-pago").removeAttr("disabled");
				break;
			default:
				fieldPadre.find(".cuenta-bancaria").attr("disabled", "true");
				fieldPadre.find(".numero-referencia").attr("disabled", "true");
				fieldPadre.find(".chequera").attr("disabled", "true");
				fieldPadre.find(".vencimiento-pago").attr("disabled", "true");
				break;
		}
	})
}
