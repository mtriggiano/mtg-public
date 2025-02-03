function toggleRejectReason() {
  if ($(".approve_toggle").is(":checked")) {
      $("#approve_attachs").removeClass('hidden');
      $("#approve_attachs").show('fast');
			$(".reject_reason").hide('fast');
      $(".reject_reason_label").hide('fast');
			$(".reject_reason").removeAttr('required');
      $(".reject_reason").attr('disabled', 'disabled')
		}
		else {
			$(".reject_reason").show('fast');
      $(".reject_reason_label").show('fast');
			$("#approve_attachs").addClass('hidden');
			$(".reject_reason").attr('required','required');
      $(".reject_reason").removeAttr('disabled');
		}
}
