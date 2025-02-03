$(document).ready(() => {
  toggleForLcAlert();
})

$(document).load(() => {
  toggleForLcAlert();
})

function toggleForLcAlert() {
  	var alertElement = $('.alert-lc');
  	if(alertElement.text().length != 0){
	  	setTimeout( () => alertElement.slideDown(), 1000 );
	  	setTimeout( () => alertElement.slideUp( "slow", function() {
    		alertElement.html("");
  		}), 6000 );

	}
}


/*$(function() {
  $(document).on('pjax:complete', function(event, xhr, settings) {
    showFlashMessages(xhr);
  });
});*/


function showFlashMessages(jqXHR) {
	if (!jqXHR || !jqXHR.getResponseHeader) return;
	flashDiv = $(".alert-lc")
	flash = jqXHR.getResponseHeader('X-Flash');
	flash = JSON.parse(flash)
  if (flash != null){
  	id = flash[2]
  	if (flash[0] == "alert") {
  		if (flashDiv.attr("id") != id){
  			$(".alert-lc-danger").html(flash[1])
  			flashDiv.attr("id", id);
  			toggleForLcAlert();
  		}
  	}else{
  		if (flashDiv.attr("id") != id){
    		$(".alert-lc-success").html(flash[1]);
    		flashDiv.attr("id", id);
    		toggleForLcAlert();
    	}
  	}
  }
}


$(document).ready(function() {
  var table = $('#alerts-datatable').DataTable({
    "language": { "url": "https://cdn.datatables.net/plug-ins/1.10.19/i18n/Spanish.json",
                  "buttons" : {
                    copyTitle: 'Añadido al portapapeles',
                    copyKeys: 'Presione <i>ctrl</i> o <i>\u2318</i> + <i>C</i> para copiar los datos de la tabla a su portapapeles. <br><br>Para cancelar, haga clic en este mensaje o presione Esc.',
                    copySuccess: {
                    _: '%d lineas copiadas',
                    1: '1 linea copiada'
                    }
                  }
    },
    "lengthMenu": [ [10, 25, 50, 100, 500], [10, 25, 50, 100, 500] ],
    "responsive": true,
    "processing": true,
    "serverSide": true,
    "initComplete": function () {
      table.buttons().container().appendTo( $('#buttons-container'));
      $("#alerts-datatable_length").appendTo( $("#length_menu") );
    },
    "ajax": $('#alerts-datatable').data('source'),
    "pagingType": "full_numbers",
    "dom": 'Bflrtip',
    "buttons": [
      {extend: 'print', text: '<i class="fas fa-print"></i> Imprimir', className: "btn-light border"},
      {extend: 'copyHtml5', text: '<i class="fas fa-copy"></i> Copiar', className: "btn-light border"}, 
      {extend: 'excelHtml5', text: '<i class="fas fa-file-excel"></i> Exportar a excel', className: "btn-light border"}, 
      {extend: 'pdfHtml5', text: '<i class="fas fa-file-pdf"></i> Exportar a PDF', className: "btn-light border"}],
    "columns": [
      {"data": "id"},
      {"data": "title"},
      {"data": "user"},
      {"data": "init_date"},
      {"data": "final_date"},
      {"data": "state"},
      {"data": "actions"}
    ],
    "columnDefs": [ 
      { "targets": 5, "orderable": false, className: "actions" }
    ]
  });
  if ($('#alerts-datatable').length) {
    $('#general_search').keyup(function(){
       table.search( $(this).val() ).draw();
    })
  }

});

