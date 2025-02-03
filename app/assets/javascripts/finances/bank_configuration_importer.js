function setDivUniqAttr(select_value) {
  if (select_value == "true") {
    $(".form-unique-amount-attr").show('fast');

    $(".form-dual-amount-attrs").hide('fast');
    $("input.credit-input").val(0);
    $("input.debit-input").val(0);
  }
  else {
    $(".form-dual-amount-attrs").show('fast');
    $(".form-unique-amount-attr").hide('fast');
    $(".uniq-attr-input").val(0)
  }
}
