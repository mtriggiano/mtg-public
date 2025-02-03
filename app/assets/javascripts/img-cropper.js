$(document).on('shown.bs.modal', '#new_cropp_modal', function(){
  $.get("/croppers/new",{}, null, "script")
  .done(function(){
    setCropper("#new_cropp_modal > .modal-body")
  })
});

$(document).on('hidden.bs.modal', '#new_cropp_modal', function(){
  $(this).find(".modal-body").html("")
});

$(document).on("click", ".cropp-btn", function(e){
  e.preventDefault();
  var textarea = $(this).closest(".form-group.summernote").find("textarea");
  $( $(this).data("target") ).attr("for-summernote", textarea.attr("id") )
  return true;
})

function setCropper(target_id){
  'use strict';
  const worker = new Tesseract.TesseractWorker();

  var Cropper = window.Cropper;
  var URL = window.URL || window.webkitURL;
  var container = document.querySelector('.img-container');
  var image = container.getElementsByTagName('img').item(0);
  var actions = document.getElementById('actions');
  var dataX = document.getElementById('dataX');
  var dataY = document.getElementById('dataY');
  // var dataHeight = document.getElementById('dataHeight');
  // var dataWidth = document.getElementById('dataWidth');
  //var dataRotate = document.getElementById('dataRotate');
  // var dataScaleX = document.getElementById('dataScaleX');
  // var dataScaleY = document.getElementById('dataScaleY');
  var options = {
    preview: '.img-preview',
    ready: function(e) {
    },
    cropstart: function(e) {
    },
    cropmove: function(e) {

    },
    cropend: function(e) {
    },
    crop: function(e) {
      var data = e.detail;
      // dataX.value = Math.round(data.x);
      // dataY.value = Math.round(data.y);
      // dataHeight.value = Math.round(data.height);
      // dataWidth.value = Math.round(data.width);
      //dataRotate.value = typeof data.rotate !== 'undefined' ? data.rotate : '';
      // dataScaleX.value = typeof data.scaleX !== 'undefined' ? data.scaleX : '';
      // dataScaleY.value = typeof data.scaleY !== 'undefined' ? data.scaleY : '';
    },
    zoom: function(e) {
    }
  };
  var cropper = new Cropper(image, options);
  var originalImageURL = image.src;
  var uploadedImageType = 'image/jpeg';
  var uploadedImageURL;

  // Tooltip
  $('[data-toggle="tooltip"]').tooltip();

  // Buttons
  if (!document.createElement('canvas').getContext) {
    $('button[data-method="getCroppedCanvas"]').prop('disabled', true);
  }

  if (typeof document.createElement('cropper').style.transition === 'undefined') {
    $('button[data-method="rotate"]').prop('disabled', true);
    $('button[data-method="scale"]').prop('disabled', true);
  }



  // Methods
  actions.querySelector('.docs-buttons').onclick = function(event) {
    var e = event || window.event;
    var target = e.target || e.srcElement;
    var cropped;
    var result;
    var input;
    var data;

    if (!cropper) {
      return;
    }

    while (target !== this) {
      if (target.getAttribute('data-method')) {
        break;
      }

      target = target.parentNode;
    }

    if (target === this || target.disabled || target.className.indexOf('disabled') > -1) {
      return;
    }

    data = {
      method: target.getAttribute('data-method'),
      target: target.getAttribute('data-target'),
      option: target.getAttribute('data-option') || undefined,
      secondOption: target.getAttribute('data-second-option') || undefined
    };

    cropped = cropper.cropped;

    if (data.method) {
      if (typeof data.target !== 'undefined') {
        input = document.querySelector(data.target);

        if (!target.hasAttribute('data-option') && data.target && input) {
          try {
            data.option = JSON.parse(input.value);
          } catch (e) {
          }
        }
      }

      switch (data.method) {
        case 'rotate':
          if (cropped) {
            cropper.clear();
          }

          break;

        case 'getCroppedCanvas':
          try {
            data.option = JSON.parse(data.option);
          } catch (e) {
          }

          if (uploadedImageType === 'image/jpeg') {
            if (!data.option) {
              data.option = {};
            }

            data.option.fillColor = '#fff';
          }

          break;
      }

      result = cropper[data.method](data.option, data.secondOption);

      switch (data.method) {
        case 'rotate':
          if (cropped) {
            cropper.crop();
          }

          break;

        case 'scaleX':
        case 'scaleY':
          target.setAttribute('data-option', -data.option);
          break;

        case 'getCroppedCanvas':
          var modal = $("#new_cropp_modal")
          var textarea = $( "#" + modal.attr("for-summernote") );
          if (result) {
            var button = $("button[data-method=getCroppedCanvas]");
            button.prop('disabled', true).html( button.data('disable-with') )
            $(".progress").removeClass("sr-only")
            // Bootstrap's Modal
            //$('#getCroppedCanvasModal').modal().find('.modal-body').html(result);
            var img = result.toDataURL()
            worker
            .recognize(img, 'spa')
            .progress((p) => {
              var progressValue = (p.progress * 100).toFixed(0);
              if (p.status === "recognizing text") {
                $(".progress-bar").attr("style", "width: " + progressValue + "%;").attr("aria-valuenow", progressValue).html(progressValue + "%");
              }
            })
            .then(({ text }) => {
              var textarea = $( "#" + modal.attr("for-summernote") );
              console.log(textarea)
              textarea.select();
              textarea.summernote('code', text);
              worker.terminate();
              button.prop('disabled', false).html( "Obtener texto" )
              $(".progress").addClass("sr-only")
              modal.modal("hide");
              cropper.destroy();
            });
          }

          break;

        case 'destroy':
          if (uploadedImageURL) {
            URL.revokeObjectURL(uploadedImageURL);
            uploadedImageURL = '';
            image.src = originalImageURL;
          }

          break;
      }

      if (typeof result === 'object' && result !== cropper && input) {
        try {
          input.value = JSON.stringify(result);
        } catch (e) {
        }
      }
    }
  };

  document.body.onkeydown = function(event) {
    var e = event || window.event;

    if (!cropper || this.scrollTop > 300) {
      return;
    }

    switch (e.keyCode) {
      case 37:
        e.preventDefault();
        cropper.move(-1, 0);
        break;

      case 38:
        e.preventDefault();
        cropper.move(0, -1);
        break;

      case 39:
        e.preventDefault();
        cropper.move(1, 0);
        break;

      case 40:
        e.preventDefault();
        cropper.move(0, 1);
        break;
    }
  };

  // Import image
  var inputImage = document.getElementById('inputImage');

  if (URL) {
    inputImage.onchange = function() {
      var files = this.files;
      var file;

      if (cropper && files && files.length) {
        file = files[0];

        if (/^image\/\w+/.test(file.type)) {
          uploadedImageType = file.type;

          if (uploadedImageURL) {
            URL.revokeObjectURL(uploadedImageURL);
          }

          image.src = uploadedImageURL = URL.createObjectURL(file);
          cropper.destroy();
          cropper = new Cropper(image, options);
          inputImage.value = null;
        } else {
          window.alert('Please choose an image file.');
        }
      }
    };
  } else {
    inputImage.disabled = true;
    inputImage.parentNode.className += ' disabled';
  }
};
