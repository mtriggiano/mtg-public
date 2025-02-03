// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require activestorage
//= require popper
//= require jquery_nested_form
//= require z.jquery.fileupload
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es.js
//= require bootstrap-datepicker-rails
//= require moment
//= require bootstrap-datetimepicker
//= require pickers
//= require bootstrap
//= require summernote/summernote-bs4.min
//= require summernote/lang/summernote-es-ES
//= require chosen-jquery
//= require select2-full
//= require select2_locale_es
//= require jquery.mask
//= require jquery.pjax
//= require private_pub
//= require cropper
//= require jquery.mousewheel
//= require pace/pace
//= require Chart.bundle
//= require chartkick
//= require reports_kit/application
//= require autoNumeric
//= require auto-numeric
//= require datatables/jquery.dataTables
//= require datatables/extensions/Buttons/dataTables.buttons
//= require buttons.html5
//= require datatables/extensions/Buttons/buttons.print
//= require datatables/extensions/Buttons/buttons.colVis
//= require datatables/extensions/Buttons/buttons.flash

//= require datatables/dataTables.bootstrap4
//= require datatables/extensions/Buttons/buttons.bootstrap4
//= require_tree .



$.fn.blank = function() {
  let value = $(this).val();
  return typeof value === "undefined" || value === "" || value == null
}

$(document).on("wheel", "input[type=number]", function (e) {
    $(this).blur();
});

function populateSelect(data, id) {
  select = $(id)
  select.html("")
  $.each(data, function(id, d) {
    select.append($("<option />").val(d.id).text(d.text));
  });
  setSelect2()
};

const copyToClipboard = str => {
  const el = document.createElement('textarea');
  el.value = str;
  document.body.appendChild(el);
  el.select();
  document.execCommand('copy');
  document.body.removeChild(el);
};

$(document).on("dblclick", "input:disabled", function(){
  copyToClipboard($(this).val())
})

$(document).on("click", "body", function(){
  let notifications = $("#notification-container")
  if ( notifications.is(":visible")){
    $("a#notifications-link").trigger("click")
  }
})

$(document).on("dblclick", "span.select2-selection__rendered", function(){
  text = $(this).closest(".form-group").find("select").text()
  copyToClipboard(text)
})

$(document).ready(function() {

  $("#yield").on("click", function() {
    $('#sidebar').addClass('active');
  });


  $('#sidebarCollapse').on('click', function() {
    // open or close navbar
    $('#sidebar').toggleClass('active');
    // close dropdowns
    $('.collapse.in').toggleClass('in');
    // and also adjust aria-expanded attributes we use for the open/closed arrows
    // in our CSS
    $('a[aria-expanded=true]').attr('aria-expanded', 'false');
  });

  $("a.final-item").on("click", function() {
    $('#sidebarCollapse').trigger("click")
  })


});

$(function() {
  setSummernote();

  $(document).pjax('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])', '#yield');
  $(document).on('nested:fieldRemoved', function(event) {
    $('[required]', event.field).removeAttr('required');
  });
  $('[data-toggle="tooltip"]:not([title=""])').tooltip({ boundary: 'window' })
  disableButtonOnSubmit()
});
$(document).on('pjax:timeout', function() {
    return false;
});
$.pjax.defaults.timeout = 4000
$(document).on("shown.bs.modal", ".modal", function() {
  $(this).find('[autofocus="autofocus"]').focus();
})

function disableButtonOnSubmit() {
  $("button[type='submit']").each(function() {
    $(this).attr("data-disable-with", '<i class="fas fa-sync"></i> Cargando...')
  })
}
//
// function openFile() {
//   $("a[data-association='attachments']").click();
// }

$(document).on('nested:fieldAdded:attachments', function(e) {
  $(e.target).find(".file_input").click();
})

$(document).on('nested:fieldAdded:budget_attachments', function(e) {
  $(e.target).find(".file_input").click();
})



$(document).on('pjax:complete', function() {
  jQuery.ready();
  setSelect2()
  setDisabledTooltips()
  setSummernote()
  $('[data-toggle="tooltip"]:not([title=""])').tooltip('enable')
  disableButtonOnSubmit()
});

function setSummernote() {
  $('[data-provider="summernote"]').each(function() {
    $(this).summernote({
      lang: 'es-ES',
      height: $(this).attr("height") || 80,
      width: '100%',
      placeholder: $(this).attr("placeholder"),
      callbacks: {
        onInit: function(e) {
          var o = e.toolbar[0];
          jQuery(o)
            .find("button:last")
            .after(
              '<button type="button" class="cropp-btn btn btn-light btn-sm" role="button" tabindex="-1" title="" data-target="#new_cropp_modal" data-toggle="modal"><i class="fas fa-crop"></i></button>'
            )
        }
      },
      codemirror: {
        mode: 'text/html',
        htmlMode: true,
        lineNumbers: true,
        lineWrapping: true,
        theme: 'monokai'
      }
    });
  })
}

$(document).on("click", "a", function(event) {
  disabled = $(this).attr("disabled") == "disabled"
  if (disabled) {
    alert("No tienes permisos para acceder a esta sección.")
    event.preventDefault();
  }
});

$(document).on("change", "#country_id", function() {
  var country_id = $(this).val();
  $.get("/get_provinces/" + country_id, {}, null, "script")
    .done(function(data) {
      populateSelect($.parseJSON(data), '#province_id');
    })
})

$(document).on("change", "#province_id", function() {
  var province_id = $(this).val();
  $.get("/consultar_localidades/" + province_id, {}, null, "script")
    .done(function(data) {
      populateSelect($.parseJSON(data), '#locality_id');
    })
})



function remoteSubmit(form_id) {
  form = $(form_id);
  $.get(form.attr("action"), form.serialize(), null, "script");
}

$(document).on("click", 'a[data-toggle="modal"]', function() {
  form_data = $(this).attr("data-form")
  modal_id = $(this).data("target")
  if (form_data == null) {
    $(modal_id).find(".modal-body").html('<div class="spinner"><div class="double-bounce1"></div><div class="double-bounce2"></div></div>');
    $.get($(this).attr("href"), {}, null, "html")
      .done(function(data) {
        from = data.indexOf("<div data-pjax-container id='yield'>");
        to = data.indexOf("</body>");
        body = data.substring(from, to);
        console.log(body)
        $(modal_id).find(".modal-body").html($(body).html());
        $(modal_id).find(".modal-body").find('[autofocus]').focus();
        setSelect2()
      })
  }
});

$(document).on("click", 'a[data-form="true"]', function() {
  modal_target = $(this).attr("data-target");
  modal_id = $(this).data("target");
  $(modal_id).find(".modal-body").html('<div class="spinner"><div class="double-bounce1"></div><div class="double-bounce2"></div></div>');
  $.get($(this).attr("href"), {}, null, "html")
    .done(function(data) {
      container = $(modal_target).find(".modal-body").closest("div"); //contenedor, aca deberia ir el form
      $(modal_target).find("div.modal-body").remove()
      from = data.indexOf("<form");
      to = data.indexOf("</form>");
      form = data.substring(from, to);
      container.html(form); // relleno el contenedor con el form
      container.find("form").find(".actions").remove()
      content = container.find("form").html(); //content es lo que esta adentro del form
      container.find("form").html('<div class="modal-body">' + content + '</div>');
      $('<div class="modal-footer"><button name="button" type="submit" class="btn btn-primary text-center"><i class="fas fa-save"></i> Guardar</button></div>').insertAfter(container.find(".modal-body"));
      container.insertAfter($(modal_target).find(".modal-header"))
      setSelect2()
      disableButtonOnSubmit();
      $(modal_id).find(".modal-body").find('[autofocus]').focus();
    });
  return false;
});



$(document).ready(function() {
  setSelect2()
  setDisabledTooltips()
});

$(document).on('nested:fieldAdded', function() {
  setSelect2();
  setDisabledTooltips();
  setSummernote();
});

$(document).on(
  'select2:close', 'select',
  function () {
      $(this).focus();
  }
);

function setSelect2(current_modal) {
  $("select[data-url], select[data-path]").each(function() {
    options = {
      language: "es",
      width: '100%',
      theme: "bootstrap4",
      allowClear: true,
      placeholder: $(this).attr("placeholder"),
      closeOnSelect: true,
      minimumInputLength: 0,
      tags: $(this).attr("tags"),
      ajax: {
        url: $(this).attr("data-url") || $(this).attr("data-path"),
        dataType: 'json',
        type: "GET",
        quietMillis: 250,
        data: function(params) {
          return {
            q: params.term,
            extra_data: $($(this).data("extraData")).val(),
            secondary_data: $($(this).data("secondaryData")).val(),
            explicit_data: $(this).closest('tr:not([class=fields]').find('select[id$=_product_id]').val(),
            page: params.page,
            for_select: true
          }
        },
        processResults: function(data) {
          return {
            results: $.map(data, function(item) {
              item["text"] = item.name || item.text || item.number
              return item;
            })
          };
        }
      }
    };

    if (current_modal == null && $(this).closest(".modal").length == 1) {
      current_modal = "#" + $(this).closest(".modal").attr("id") + " .modal-content"
    }

    if (current_modal != null) {

      $.extend(options, {
        dropdownParent: $(current_modal)
      })
      current_modal = null
    }

    $(this).select2(options);
    var attr = $(this).attr('autofocus');
    if (typeof attr !== typeof undefined && attr !== false && $(this).val() === "") {
      $(this).select2("open")
    }

  })

  $("select:not([data-path], [data-url], [readonly='true'], [disabled='true'], [data-disabled-select=true])").each(function() {
    options = {
      theme: "bootstrap4",
      width: '100%',
      tags: $(this).attr("tags"),
      disabled: $(this).hasClass("disabled") == true,
      language: "es"
    };
    $(this).select2(options);
  });

  $('.select2-selection__rendered').removeAttr('title');
  $('.select2-selection').removeAttr("aria-haspopup");
  $('.select2-selection__rendered').unbind('mouseenter mouseleave');

}


function setDisabledTooltips() {
  $('input:disabled:not([data-unwrapp=true]), textarea:disabled').each(function() {
    if (!$(this).parent().hasClass('added-tooltip')) {
      $(this).wrap('<div data-title="No se puede modificar." data-toggle="tooltip" class="added-tooltip">');
    }
  })

  $('select:disabled').each(function() {
    if (!$(this).parent().hasClass('added-tooltip')) {
      $(this).closest("div").find(".chosen-container").wrap('<div data-title="No se puede modificar." data-toggle="tooltip" class="added-tooltip">');
    }
  })
  $(".added-tooltip").tooltip({ boundary: 'window' });
};

function removeDisabledTooltip(e) {
  if (e.parent().is('.added-tooltip')) {
    e.unwrap();
  }
};

function setDisabledTooltip(e) {
  if (e.is('input') || e.is('textarea')) {
    e.wrap('<div data-title="No se puede modificar." data-toggle="tooltip" class="added-tooltip">');
  }

  if (e.is('select')) {
    e.closest("div").find(".chosen-container").wrap('<div data-title="No se puede modificar." data-toggle="tooltip" class="added-tooltip">');
  }
  $(".added-tooltip").tooltip({ boundary: 'window' });
};

$(document).on("submit", "form", function() {
  $("select, input").each(function() {
    $(this).removeAttr("disabled");
  })
})

$(document).on("click", ".toggle-card > .card-header", function() {
  $(this).closest(".card").addClass("center-card")
  $(this).next(".card-body").toggle("slow");
})

function toggleHeader() {
  if ($(".header-detail").is(":visible")) {
    $(".header-detail").hide("fast");
    $(".header-detail").closest(".card").find("h5").find("button").html('<i class="fas fa-eye"></i>')
  } else {
    $(".header-detail").show("fast")
    $(".header-detail").closest(".card").find("h5").find("button").html('<i class="fas fa-eye-slash"></i>')
  }

}

function hideAttachments() {
  if ($(".attachments").is(":visible")) {
    $(".attachments").hide("fast");
    $("button.hide_button").html('<i class="fas fa-eye"></i> Mostrar adjuntos')
  } else {
    $(".attachments").show("fast")
    $("button.hide_button").html('<i class="fas fa-eye-slash"></i> Ocultar adjuntos')
  }
}

function round(value, precision) {
  var aPrecision = Math.pow(10, precision);
  return Math.round(value * aPrecision) / aPrecision;
};

$(document).on({
  mouseenter: function() {
    $(this).closest(".mx-2").find(".rm-img-btn.remove_nested_fields").show("slow")
  },
  mouseleave: function() {
    $(this).closest(".mx-2").find(".rm-img-btn.remove_nested_fields").hide("slow")
  }
}, "#image")


$(document).on("focusout", "input[type=text]:not([data-downcase=true], [type=password],[type=email])", function() {
  $(this).val(makeTitle($(this).val()))

});

function makeTitle(slug) {
  words = slug.charAt(0).toUpperCase() + slug.slice(1);
  return words
}

$(document).on("click", "button[type=submit]", function(e) {
  $("input:hidden, select:hidden, textarea:hidden").each(function() {
    var $input = $(this);
    $input.removeAttr("required");
  });
});

$(document).bind("ready ajaxComplete pjax:complete", function() {
  $("td").each(function() {
    $(this).attr("title", $(this).find("input").val());
    $(this).attr("title", $(this).find("select option:selected").text());
    $(this).attr("toggle", "tooltip");
    if ($(this).find("div[data-toggle='tooltip']").length){
      $(this).removeAttr("title").removeAttr("toggle")
    }
  })
})
