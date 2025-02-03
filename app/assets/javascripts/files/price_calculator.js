
function decimalAdjust(type, value, exp) {
    exp = -2
    // Si el exp no está definido o es cero...
    if (typeof exp === 'undefined' || +exp === 0) {
      return Math[type](value);
    }
    value = +value;
    exp = +exp;
    // Si el valor no es un número o el exp no es un entero...
    if (isNaN(value) || !(typeof exp === 'number' && exp % 1 === 0)) {
      return NaN;
    }
    // Shift
    value = value.toString().split('e');
    value = Math[type](+(value[0] + 'e' + (value[1] ? (+value[1] - exp) : -exp)));
    // Shift back
    value = value.toString().split('e');
    return +(value[0] + 'e' + (value[1] ? (+value[1] + exp) : exp));
}

if (!Math.round10) {
    Math.round10 = function(value, exp) {
        return decimalAdjust('round', value, exp);
    };
}

// Llama al calcular subtotal cuando cambia el precio, el descuento o la cantidad
$(document).on("change", "[id$=_price]:not([id=supplier_price]), [id$=_discount], [force-reverse=true], [id$=_quantity], [id$=_iva_aliquot], [id*=details][id$=_total]", function(){
    tr = $(this).closest("tr.fields")
    console.log("KJASKJLADKJLADKJLADJÑLADSJLADS")
    var total = tr.find("input[id$=_total]")
    calculateSubtotalWithIVA(tr, $(this));
    runTaxes();
});

$(document).on("change", "[id$=_base_offer]", function(){
  tr = $(this).closest("tr.fields")
  var total = tr.find("input[id$=_total]:not([data-reversible=false])")

  if (total.attr("force-reverse") == "true") {
    $(this).closest("tr").find("[id$=_total]").trigger("change")
  }else{
    $(this).closest("tr").find("[id$=_price]").trigger("change")
  }
})

$.fn.isBaseDetail = function(){
    const baseOffer = $(this).find("input[id$=base_offer]")
    if (baseOffer.length > 0){
        return baseOffer.is(":checked")
    }else{
        return true
    }
}

  function setIvaAmount(tr){
    const price           = parseFloat(tr.find("input[id$=_price]").val());
    const quantity        = parseFloat(tr.find("input[id$=_quantity]").val());
    const discount        = parseFloat(tr.find("input[id$=_discount]").val());
    var iva_aliquot       = parseFloat(tr.find("select[id$=_iva_aliquot] option:selected").text());
    if (isNaN(iva_aliquot)){ iva_aliquot = 0 }

    const iva_amount        = parseFloat( ((price * quantity) * (1 - (discount / 100))) * iva_aliquot );
    const iva_input         = tr.find("input[id$=_iva_amount]");
    iva_input.val( Math.round10(iva_amount) );
  }

// Calcula el subtotal cuando cambia el precio, la cantidad o el descuento
  function calculateSubtotalWithIVA(tr, changed){
    var price             = tr.find("input[id$=_price]");
    const quantity        = parseFloat(tr.find("input[id$=_quantity]:not([id$=_sended_quantity])").val());
    var discount        = parseFloat(tr.find("input[id$=_discount]").val());
    var iva_aliquot       = parseFloat(tr.find("select[id$=_iva_aliquot] option:selected").text());
    var total             = tr.find("input[id$=_total]");
    const iva_input       = tr.find("input[id$=_iva_amount]");

    if (isNaN(iva_aliquot)){ iva_aliquot = 0 }
    if (isNaN(discount)) {discount = 0}
    //|| changed.attr("force-reverse") == "true
    if (typeof changed == 'undefined' || changed.attr("id") == total.attr("id") || changed.attr("force-reverse") == "true"){
        const calculatedPrice   = parseFloat( total.val() / ( quantity * ( 1 + iva_aliquot) * (1- discount / 100 ) ) )
        const iva_amount        = parseFloat( ((calculatedPrice * quantity) * (1 - (discount / 100))) * iva_aliquot );
        price.val( ( calculatedPrice ).toFixed(4) )
        iva_input.val( iva_amount.toFixed(4) );
    }else{
      console.log("ELSE")
        const iva_amount        = parseFloat( ((price.val() * quantity) * (1 - (discount / 100))) * iva_aliquot );
        const total_with_iva    = parseFloat((price.val() * quantity) * (1 - (discount / 100)) + iva_amount) ;

        iva_input.val( iva_amount.toFixed(4) );

        total.val( total_with_iva.toFixed(4) )
    }
    calculateHeader()
  }

const calculateSupplierTotal = () => {
    const total = $("[id$=_supplier_price]:visible").toArray().reduce( (total, current) => {
        return total + parseFloat($(current).val() || 0)
    }, 0)

    return Math.round10(total)
}

$(document).on("change", "[id$=_supplier_price]", function(){
    calculateHeader()
})

// Calcula el total y el descuento general del documento
  $(document).on("change", "input[id$=_total]:not([id=parent_total]):not([data-reversible=false]), [id$=total_trib], [id$=_amount], [id$=_quantity], [id$=iva_aliquot]", function(){
    //reversePriceCalculator($(this));
    calculateHeader();
  });

  $(document).on("change", "#parent_usd_price", function(){
    calculateHeader();
  });

  function reversePriceCalculator(element){
    tr = element.closest("tr");
    subtotal    = element.val();
    quantity    = tr.find("[id$=quantity]");
    unit_price  = tr.find("[id$=price]");
    discount    = tr.find("[id$=discount]");
    iva         = tr.find("[id$=iva_aliquot] option:selected");


    if (iva.text() == "Exento" || iva.text() == "No gravado") {
      iva_text = "0"
    }else{
      iva_text = iva.text()
    }

    if (isNaN(unit_price.val())) { unit_price.val(0)}

    if (quantity.val() != null && quantity.val() != 0){
      current_subtotal = parseFloat(unit_price.val() * quantity.val()) * (1 - parseFloat(discount.val()) / 100) * ( 1 + parseFloat(iva_text) );
      if (current_subtotal != subtotal) {
        dividend = ( parseFloat(quantity.val()) * (1 - parseFloat(discount.val()) / 100) * ( 1 + parseFloat(iva_text)) )
        if (dividend > 0) result = subtotal / dividend
        else result = 0
        unit_price.val( result.toFixed(4) )
      }

    }
  }

  function calculateHeader(){
    data = calculateSeveral()
    let sumTotal        = Math.round10(calculateTotal())
    let sumNeto         = Math.round10((data.sumNeto))
    let gross           = Math.round10(data.gross)
    let totalDiscount   = Math.round10(data.totalDiscount)
    let sumIva          = Math.round10(calculateIva())
    let shipping        = Math.round10(calculateShipping())

    let dolar_price = setDolarPrice()

    let total_gross             = Math.round10(gross + shipping);
    let total                   = Math.round10(sumTotal) + Math.round10(totalDiscount)
    let totalDiscountPercentage = Math.round10(totalDiscount * 100 / total)
    let total_usd               = Math.round10(total_gross / Math.round10(dolar_price));

    if (isNaN(totalDiscountPercentage)) { totalDiscountPercentage = 0; }
    $("#parent_gross_price").val(Math.round10(total_gross));
    $("#parent_iva_amount").val(sumIva);
    $("#parent_subtotal").val(Math.round10(sumNeto));
    $("#parent_total").val(Math.round10(sumTotal));
    $("#parent_total_usd").val(Math.round10(total_usd));
    $("#parent_discount").val(Math.round10(totalDiscount))
    $("span.discount_in_percentage").html(Math.round10(totalDiscountPercentage) + "%")
    $("#modal_total").html(`$ ${Math.round10(sumTotal)}`)
  }

const calculateTotal = () =>{
    var sumTotal = 0;
    const shippingPrice = $("[id$=_shipping_price]").val();
    // const totalTrib = $("[id$=_total_trib]").val();
    const totalTrib = getTributes()
    if ($("[id$=_supplier_price").length == 0){
        sumTotal = sumDetailTotal("input[id$=_total]:not([id=parent_total])")

        if ( shippingPrice != null) {
            sumTotal += Math.round10(shippingPrice);
        }
        if ( totalTrib != null) {
            sumTotal += Math.round10(totalTrib);
        }

    }else{
        sumTotal = calculateSupplierTotal()
    }
    return sumTotal
}

const sumDetailTotal = (attr) => {
    var sumTotal = 0;
    $(attr).each(function(){
        const tr = $(this).closest(".fields[id^=parent_]");
        const destroyed = tr.find("input[id$=_destroy]").val();
        if (destroyed != "false"){ return true }
        if (!tr.isBaseDetail()){ return true }
        select = tr.find("select[id$=_state]");
        if (select.find(':selected').text() != "Rechazado"){
            sumTotal += Math.round10($(this).val());
            $(this).removeClass("border border-warning dissaproved")
        }else{
            $(this).addClass("border border-warning dissaproved")
        }
    });
    return sumTotal
}

const calculateSeveral = () =>{
    var sumNeto         = 0;
    var gross           = 0;
    var totalDiscount   = 0;

    $("input[id$=_discount]:not([id=parent_discount])").each(function(){
        const select = $(this).closest(".fields[id^=parent_]").find("[id$=_state]");
        const tr = $(this).closest(".fields");
        const destroyed = tr.find("input[id$=_destroy]").val()
        if (destroyed != "false"){ return true }
        if (select.find(':selected').text() === "Rechazado"){
            $(this).addClass("border border-danger dissaproved");
            return true;
        }

        if (!tr.isBaseDetail()) {
            return true;
        }

        $(this).removeClass("border border-danger dissaproved")

        const price     = parseFloat(tr.find("input[id$=_price]").val());
        const quantity  = parseFloat(tr.find("input[id$=_quantity]").val());
        const discount  = parseFloat(tr.find("input[id$=_discount]").val());
        var iva         = parseFloat(tr.find("select[id$=_iva_aliquot] option:selected").text());

        if (discount == null) { discount = 0; }
        if (isNaN(iva)) {iva = 0;}

        const currentNeto    = price * quantity * (1 + (discount / 100)); //* (1 + iva));

        sumNeto             += currentNeto;
        gross               += price * quantity * (1 - discount /100);
        totalDiscount       += price * quantity * ( discount / 100 );
    });
    return {sumNeto: Math.round10(sumNeto), gross: Math.round10(gross), totalDiscount: Math.round10(totalDiscount)}
}

const calculateIva = () =>{
    var sumIva = 0;
    $("input[id$=_iva_amount]:not([id=parent_iva_amount])").each(function(){
        const tr = $(this).closest("tr[id^=parent_]");
        const destroyed = tr.find("input[id$=_destroy]").val()
        if (destroyed != "false"){ return true }
        if (!tr.isBaseDetail()){ return true }
        setIvaAmount(tr)
        select = tr.find("select[id$=_state]");

        if (select.find(':selected').text() === "Rechazado" ){
            $(this).addClass("border border-danger dissaproved");
            return true
        }
        sumIva += parseFloat($(this).val())
        $(this).removeClass("border border-danger dissaproved")
    });
    return sumIva
}

const calculateShipping = () => {
  let shipping = Math.round10($("input[name$='[shipping_price]']").val())

  if (isNaN(shipping)) { shipping = 0 }
  return shipping
}

const setDolarPrice = () => {
  price = $("#parent_usd_price").val();

  if (price <= 0) {
    $("#parent_usd_price").val($("#parent_usd_price").data("default"));
    price = $("#parent_usd_price").data("default");
  }
  return price
}
