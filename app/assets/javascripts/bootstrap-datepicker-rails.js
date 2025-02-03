function initDatePicker(){
  $('input[data-behaviour="datepicker"]').datepicker({
        language: "es",
        dateFormat: "dd/mm/yyyy",
        autoclose: true,
        startView: 2,
        todayBtn: true,
        position: 'bottom'
    });
  $('input[data-behaviour="timepicker"]').datetimepicker({
      format: 'LT'
    });
  $(".bootstrap-datepicker").attr('autocomplete','off');
}
$(document).ready(function(){
	initDatePicker()
});

$(document).ajaxComplete(function(event, jqXhr, settings) {
  initDatePicker()
})

$(document).on('pjax:complete', function() {
    initDatePicker()
});


$(document).on('nested:fieldAdded', function() {
    initDatePicker()
})

$(document).on('changeDate clearDate', '.bootstrap-datepicker', function(evt){
	if (evt.date){
    	rails_date = evt.date.getFullYear() + '-' + ('0' + (evt.date.getMonth() + 1)).slice(-2) + '-' + ('0' + evt.date.getDate()).slice(-2)
	}else{
		rails_date = ''
	}
    $(this).next("input[type=hidden]").val(rails_date)
 })
