/// Autor: Facundo Adrián Diaz Martinez
/// Coautor: Ariel Agustín García Sobrado
///
/// Responsabilidad: Cálculos de Frontend para el registro de recibos.
///
/// Un recibo de cobro contiene los comprobantes a pagar, las formas de cobro y las percepciones sufridas.
///
/// Vistas enfocadas: expedient_receipts
///

// INICIALIZADORES
$(document).on("pjax:complete ready", function() {
	receiptTotal()
})


// AL SELECCIONAR EL CLIENTE
$(document).on("select2:select", "#expedient_receipt_entity_id", function(e){
	$("#client_current_balance").val(e.params.data.current_debt)
	refreshSaldo()
	receiptTotal()
})

$(document).on("change", "#client_current_balance", function(){
	current_debt = Math.round10($(this).val() || 0);
	$("td.saldo").each( (index, saldo) => {
		$(saldo).html(`$${current_debt}`)
	})
})

// COMPROBANTES A PAGAR

$(document).on("select2:select", "select[id*=receipt_receipt_details_attributes][id$=_bill_id]", function(e){
	var data = e.params.data;
	var total_left = data.total_left;
	try {
		if (data.text.includes("NCB")){
			total_left = total_left * -1
	    }
	}
	catch (e) { }
	$(e.currentTarget).closest(".fields").find("input[id$=_total_left]").data("original", total_left)
	$(e.currentTarget).closest(".fields").find("input[id$=_total]").val(total_left)
	// refresh(data.id)
	receiptTotal()
})

$(document).on("focus", "input[id*=receipt_receipt_details_attributes][id$=total]", function() {
	$(this).data("previous", $(this).val());
})

$(document).on("change", "input[id*=receipt_receipt_details_attributes][id$=total]", function() {
	const tr 			= $(this).closest(".fields");
	var   billId  = tr.find("select[id$=bill_id]").val();
	if (billId) refresh(billId);
})

$(document).on("change", ".suma-parent-total", function() { receiptTotal() })
$(document).on("nested:fieldRemoved:receipt_details", function() { receiptTotal() })
$(document).on("nested:fieldAdded:receipt_details", function() { refreshSaldo() })


// FORMAS DE COBRO

$(document).on("select2:open", "select[id$=payment_type_id]", function() {
	$(this).data( "previous", $("option:selected", this).text() );
}).on("change", "select[id$=payment_type_id]", function() {
	const previous = $(this).data("previous");
	if (previous == "Cta. Corriente"){ refreshSaldo() }
})

$(document).on("select2:select", "select[id^=expedient_receipt_payments_attributes][id$=_payment_type_id]", () => {	checkPaymentsAttrsByCollectType() })

$(document).on("nested:fieldAdded:payments pjax:complete ready", () => { checkPaymentsAttrsByCollectType() })


// FUNCIONES

function receiptTotal() {
	let totalComprobantes = 0
	$('.suma-parent-total:visible').each( (e, element) => {
		if ($(element).val()) {
			totalComprobantes += parseFloat($(element).val())
		}
	})
	$('#expedient_receipt_total').val(totalComprobantes.toFixed(2))
	return Math.round10(totalComprobantes)
}

function refreshSaldo(){
	var saldo = $("#client_current_balance");
	var saldo_actual = $.makeArray($("input[id*=receipt_receipt_details_attributes][id$=_total]")).reduce( (result, curr) => {
		return result -= Math.round10($(curr).val())
	}, Math.round10(saldo.val()) )

	$("td.saldo").each( (index,curr) => {
		$(curr).html(`$${saldo_actual}`)
	})
}

function setTotalLeft(billId, total_left) {
	var selectedBill = $(`select:visible[id$=_bill_id] option:selected[value=${billId}]`)
	selectedBill.each( (e, element) => {
		$(element).closest(".fields").find("input[id$=total_left]").val(total_left.toFixed(2))
	})
}


// VARS

const totalLeft = (id) => {
	// devuelve el saldo de cada factura seleccionada
	return $(`select:visible[id$=_bill_id] option:selected[value=${id}]`)
		.closest(".fields")
		.find("[id$=_total_left]").data("original")
}

const refresh = invoiceId => {
	// actualiza el saldo a partir del Total a pagar
	const total_pagado 	= getTotalPaidFor(invoiceId);
	const a_total_left 	= totalLeft(invoiceId)
	var total_left 			= a_total_left - total_pagado
	setTotalLeft(invoiceId, total_left);
}
