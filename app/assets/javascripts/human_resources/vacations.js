  function calcTotalVacationDay() {
    var days = 0;
    var inputs = $(".days_calc");
    for(var i = 0; i < inputs.length; i++){
      if ($(inputs[i]).is(":visible")){
        days += parseInt($(inputs[i]).val());
      }
    }
    $(".total_days").val(days);

  }

  function setMaxDays(user_debt_vacation_id, index) {
    $.ajax({
          url: "/human_resources/user_vacations/get_max_days_for_vac_days",
          type: "get",
          data: {
            user_debt_vacation_id: user_debt_vacation_id,
          },
          cache: false,
          success: function(data) {
            if (data["error"] = "no_error") {
              $(".days_" + index).attr('max', data["max_days"]);
            }
            else if (data["error"] == "error")  {
              $(".days_" + index).removeAttr('max');
            }
          },
          error: function(data){
            $(".days_" + index).removeAttr('max');
          }
      });
  }

  function setVacationsSelect() {
		var user_id = $("#user_vacation_user_id").val();
    if (user_id != "")
		{
      $("#query_user_id").val(user_id);
		  sendYearsRequest(user_id);
    }
	}

  function sendYearsRequest(user_id) {
    const url = "/human_resources/user_vacations/fill_days_asignations";
    const params = {
      "user_id": user_id
    }
    $.get(url, params, null, "script")
    .done(function(){
      console.log("sended");
    });
  }

  $("#vacations_form").on('nested:fieldRemoved', function (event) {
  //$('[required]', event.field).removeAttr('required'); //Quita el atributo required de los inputs
    event.field.remove(); //Elimina del DOM al tr.fields removido
    calcTotalVacationDay();
  });
