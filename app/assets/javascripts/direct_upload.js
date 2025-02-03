$(document).on("ready ajaxComplete", function(){
  initializeImageUpload()
})

function initializeImageUpload(){
  fileType = "";
  fileName = "";
  $('.directUpload').find("input:file").each(function(i, elem) {
    var fileInput    = $(elem);
    fileInput.attr('required', false);
    fileInput.attr('aria-required', false);
    var form         = $(fileInput.parents('form:first'));
    var submitButton = form.find('input[type="submit"]');
    var parent_row   = fileInput.closest(".row");
    var img_width    = parent_row.find(".image").width();
    var img_height   = parent_row.find(".image").height();
    var fd           = form.data('form-data');
    fileInput.fileupload({
      add: function(event, data) {
        var file = data.files[0];
        fileType = file.type;
        fileName = file.name;
        fd["Content-Type"] = data.files[0].type;
        data.formData = fd;
        data.submit();
      },
      fileInput:       fileInput,
      url:             form.data('url'),
      type:            'POST',
      autoUpload:       true,
      formData:         fd,
      paramName:        'file', // S3 does not like nested name fields i.e. name="user[avatar_url]"
      dataType:         'XML',  // S3 returns XML if success_action_status is set to 201
      replaceFileInput: true,
      start: function (e) {
        submitButton.prop('disabled', true);
        parent_row.find(".image").removeClass("hidden");
        parent_row.find('.caption').width(img_width).height(img_height).slideDown(250);
      },
      done: function(e, data) {
        submitButton.prop('disabled', false);
        // extract key and generate URL from response
        var key   = $(data.jqXHR.responseXML).find("Key").text();
        var url   = 'https://' + form.data('host') + '/litecode.facturacion/' + key;

        // create hidden field
        if (!parent_row.find(".hidden_photo").length){
          var input = $("<input />", { type:'hidden', name: fileInput.attr('name'), value: url, class: 'hidden_photo' })
        }else {
          parent_row.find(".hidden_photo").val(url);
        }
        parent_row.append(input);
        if (!~'application/pdf application/msword application/vnd.ms-excel'.indexOf(fileType.toLowerCase())) {
          parent_row.find(".image").attr("src", url);
        }
        if (parent_row.hasClass('with-title')) {
          parent_row.find("[id$=_original_filename]").val(fileName).attr("type", "text").removeClass("hidden").parent().removeClass("hidden")
        }
        parent_row.find('.caption').slideUp(250); //.fadeIn(250)
      },
      fail: function(e, data) {
        submitButton.prop('disabled', false);
      }
    });
  });

}


$(document).on("click", ".image", function(){
  $(this).closest("div.row").find("input:file").first().click();
})
