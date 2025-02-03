//Global setting and initializer
// Date range filter
minDateFilter = "";
maxDateFilter = "";
$.extend( $.fn.dataTable.defaults, {
  "language": { "url": "https://cdn.datatables.net/plug-ins/1.10.19/i18n/Spanish.json",
    "buttons" : {
      copyTitle: 'Añadido al portapapeles',
      copyKeys: 'Presione <i>ctrl</i> o <i>\u2318</i> + <i>C</i> para copiar los datos de la tabla a su portapapeles. <br><br>Para cancelar, haga click en este mensaje o presione Esc.',
      copySuccess: {
      _: '%d lineas copiadas',
      1: '1 linea copiada'
      }
    }
  },
  "orderCellsTop": true,
  "responsive": true,
  "order": [[ 0, "desc" ]],
  "autoWidth":  false,
  "lengthMenu": [ [10, 25, 50, 100, 500, 1000], [10, 25, 50, 100, 500, 1000] ],
  "processing": true,
  "serverSide": true,
  "bSort": false,
  "ajax": $('table').data('source'),
  "dom": 'Bflrtip',
  "bStateSave": true,
  "buttons": [
    {extend: 'print', text: '<i class="fas fa-print"></i> Imprimir', className: "btn-light border",
      customize: function(win){
        $.each($(win.document.body).find( 'th' ), function(index, obj){
          from = 0;
          to = $(obj).html().indexOf('"&gt;');
          $(obj).html($(obj).html().substr(from, to))
        })
      }},
    {extend: 'copyHtml5', text: '<i class="fas fa-copy"></i> Copiar', className: "btn-light border",
      customize: function(win){
        $.each($(win.document.body).find( 'th' ), function(index, obj){p
          from = 0;
          to = $(obj).html().indexOf('"&gt;');
          $(obj).html($(obj).html().substr(from, to))
        })
      }},
    {extend: 'excelHtml5', filename: "reporte" ,text: '<i class="fas fa-file-excel"></i> Exportar a excel', className: "btn-light border"
    , title: () => {
      return $("#paginated_table").attr("data-title") || "Datos solicitados"
      }
    },
    {extend: 'pdfHtml5', orientation: 'landscape', text: '<i class="fas fa-file-pdf"></i> Exportar a PDF', className: "btn-light border",
      title: () => {
        return $("#paginated_table").attr("data-title") || "Datos solicitados"
        },
      // customize: function(doc){
      //   console.log(doc.content[1].table)
      //   $.each(doc.content[1].table.body[0], function(index, obj){
      //     from = 0;
      //     to = obj.text.indexOf('">');
      //     obj.text = obj.text.substr(from, to)
      //   })
      // }
    }
  ]
});

$attempts = 0

// $.fn.dataTableExt.oApi.fnSortNeutral = function ( oSettings )
// {
//     /* Remove any current sorting */
//     oSettings.aaSorting = [];

//     /* Sort display arrays so we get them in numerical order */
//     oSettings.aiDisplay.sort( function (x,y) {
//         return x-y;
//     } );
//     oSettings.aiDisplayMaster.sort( function (x,y) {
//         return x-y;
//     } );

//     /* Redraw */
//     if ($attempts == 0){
//       oSettings.oApi._fnReDraw( oSettings );
//     }
// };

$.fn.dataTable.ext.errMode = function ( settings, helpPage, message ) {
  $('table.dataTable').dataTable().fnSortNeutral();

  $('table.dataTable').DataTable().columns().eq( 0 ).each( function ( colIdx ) {
      $('input', $('.filters th')[colIdx]).val("");
  });
  if ($attempts == 0){
    $attempts += 1
    table.draw();
  }
};

const applyFilters = (table) => {
  var state = table.state.loaded();
  if ( state ) {
    table.columns().eq( 0 ).each( function ( colIdx ) {
    var colSearch = state.columns[colIdx].search;

    if ( colSearch.search ) {
      $('input', $('.filters th')[colIdx]).val( colSearch.search );
    }
   });

   table.draw();
  }
}

function isValidDate(dateString) {
  var regEx = /^\d{4}-\d{2}-\d{2}$/;
  return dateString.match(regEx) != null;
}

function getColumnDefs(){
  var columnDefs = [{ "targets": $("table thead tr:last th").length - 1, "orderable": false, 'className': 'actions' }]
  var invisibles = []
  $("table.dataTable thead tr:last th").each(function(index){
    if ($(this).text().match(":invisible$")) {
      $(this).text($(this).text().replace(":invisible", ""))
      invisibles.push({ "targets": index, "visible": false })
    }
  });
  result = $.merge(columnDefs,invisibles)
  return result
}


$(document).on('preInit.dt', function(e, settings) {
  var api, table_id, url;
  api = new $.fn.dataTable.Api(settings);
  table_id = "#" + api.table().node().id;
  url = $(table_id).data('source');
  if (url) {
    return api.ajax.url(url);
  }
});


// init on turbolinks load
$(document).on('turbolinks:load', function() {
  if (!$.fn.DataTable.isDataTable("table[id^=dttb-]")) {
    $("table[id^=dttb-]").DataTable();
  }
});

// turbolinks cache fix
$(document).on('unload', function() {
  var dataTable = $($.fn.dataTable.tables(true)).DataTable();
  if (dataTable !== null) {
    dataTable.clear();
    dataTable.destroy();
    return dataTable = null;
  }
});



var table;
function setSearchFields (settings, json, columns){
  oTable = settings.oInstance.api();
  var result = [];
  $.each(Object.keys(columns), function( index, column) {
    if (columns[column]['cond'] == 'date_range'){
      result.push({
        column_number: index,
        filter_type: "range_date",
        date_format: "dd/mm/yyyy",
        filter_delay: 500
      })
    }else if (columns[column]['searcheable'] != false && column != 'actions'){
      result.push({
        column_number: index,
        filter_type: "text",
        filter_delay: 500
      })
    }
  })
  yadcf.init(oTable, result)
  yadcfAddBootstrapClass()
}

function yadcfAddBootstrapClass() {
    var filterReset = $('.yadcf-filter-reset-button');
    filterReset.addClass('btn btn-default').html('<i class="fas fa-trash"></i>');
    $('.yadcf-filter-wrapper').addClass('hidden');
    $('.yadcf-filter-wrapper').each( (index, obj) => {
      var filter = $(obj).clone()

      var input = filter.find('input');
      const text = $(obj).closest("th").text()
      $.each(input, (i, obj) => {
        input.addClass("form-control")
        $(obj)
          .attr("onchange", "triggerChange('" + $(obj).attr('id') + "', $(this).val())")
          .attr("onkeyup", "triggerChange('" + $(obj).attr('id') + "', $(this).val())")
          .attr("id", Math.random())
          .removeAttr('onkeydown')
        if ($(obj).hasClass('yadcf-filter-range-start')){
          $(obj).attr('placeholder', 'Desde')
            .attr("data-behaviour", "datepicker")
            .addClass("date_picker form-control")
        }else if ($(obj).hasClass('yadcf-filter-range-end')){
          $(obj).attr('placeholder', 'Hasta')
            .attr("data-behaviour", "datepicker")
            .addClass("date_picker form-control")
        }else{
          $(obj).attr('placeholder', text)
        }
      })


      $('.yadcf-filter-range-start').attr("placeholder", "DESDE");
      $('.yadcf-filter-range-finish').attr("placeholder", "HASTA");

      $(obj).closest('th').popover({
        html: true,
        placement: 'top',
        container: '#yield',
        title: text.toLowerCase(),
        content: function(){
          var container = $("<div></div>");
          var buttonContainer = $('<div class="d-flex justify-content-center"></div>');
          var button = filter.find('button');
          button.attr("onclick", "resetFilter($(this))")
          const fullButton = buttonContainer.html(button.prop('outerHTML'));
          const closeButton = $("<button class='btn btn-default yadcf-filter-reset-button close-filter'><i class='fas fa-times'></i></button>")
          buttonContainer.append(closeButton)

          return container.html(input).append("<hr class='dotted'/>").append(buttonContainer);
        }
      }).on('shown.bs.popover', function(){
        offset = $(this).closest('th').offset()
        width = $(this).closest('th').outerWidth()
        id = "#" + $(this).attr("aria-describedby");
        t = offset.top - $(id).outerHeight() - 10
        l = offset.left

        $(id).attr("style", "transform: translate3d(" + l + "px, " + t +"px, 0px); width: " + width + "px;")
        $('.arrow').hide()
      })
    })
};

$(document).on("click","button.close-filter", function(){
  $(this).closest(".popover").popover("hide")
})

function triggerChange(id,val){
  $("input#" + id).val(val).trigger("keydown").trigger("keyup")
}

function resetFilter(button){
  var inputs = button.closest(".popover-body").find("input");
  $.each(inputs, (i, obj) => {
    $(obj).val(null).trigger("change")
  })
}

function clearFilter(button){
  var inputs = button.closest("th").find("input");
  $.each(inputs, (i, obj) => {
    $(obj).val("").trigger("keyup")
  })
}

var getExcel = function (xlsx){
  var sheet = xlsx.xl.worksheets['sheet1.xml'];
  for (var i = 0; i < data.body.length; i++) {
    if (row[i].match && (!row[i].match(/^0\d+/) || special.style>=67) && row[i].match(special.match)) {
      var val = row[i];
      if (special.style<67) val=val.replace(/[^\d\.\-]/g, '');
    }
  }

}

$(document).on("pjax:complete", function(){
  $('.popover').popover('dispose')
});

const setDataTable = (col_a, col_b) => {
    result = getColumnDefs()
    var table = $('#paginated_table').DataTable({
      'columns': col_a,
      'initComplete': function (settings, json) {
        $('#bmenu').html('<div></div>');
        $('#bmenu').append(table.buttons().container());
        $('#bmenu').append($('#paginated_table_length'));
        setSearchFields(settings, json, $.parseJSON(col_b));

      },
      'dataSrc': function ( json ) {
        $attempt = 0;
        return json.data;
      },
      'columnDefs': result
    });
    if ($('#paginated_table').length) {
      applyFilters(table)
      $(document).on('keyup','#general_search', function(){
         table.search( $(this).val() ).draw();
      })
    }
}


const clearDataTable = () => {
  var dataTable = $($.fn.dataTable.tables(true)).dataTable();
  if (dataTable !== null) {
    dataTable.fnClearTable();
    dataTable.fnDestroy();
    return dataTable = null;
  }
};


// turbolinks cache fix
$(document).on('pjax:beforeSend', function() {
  clearDataTable()
});
