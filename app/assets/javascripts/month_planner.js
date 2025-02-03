$(document).on('click', '.date-plan', (e) => {
  fecha = $(e.target).data('date-info')
  bankAccountID = $(e.target).data('bank-account')
  if ((fecha) && (bankAccountID)) {
    fetch(`/bank_accounts/${bankAccountID}/date_resume?date='${fecha}'`, {
      headers:{
        'Content-Type': 'application/json'
      }
    }).then( res => res.json() )
      .then( response => {
          showDateResume()
          completeDateResume(response)
          console.log(response.fecha)
          console.table(response.recibidos)
          console.table(response.emitidos)
        }
      )
  }
})

function showDateResume() {
  $('.date-resume p').hide()
  $('.date-resume-body').show()
}

function completeDateResume(response) {
  fecha = response.fecha
  $('.date-resume-body h3').text(fecha.replace(/'/g, ""))
}
