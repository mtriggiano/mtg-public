$(function() {
  var fieldsCount,
      maxFieldsCount = 5

  function toggleAddLink() {

    if (fieldsCount == maxFieldsCount) {
      $('a.add_nested_fields[data-association=images]').hide()
    }else{
      $('a.add_nested_fields[data-association=images]').show()
    }
  }

  $(document).on('nested:fieldAdded:images', function() {
    fieldsCount += 1;
    toggleAddLink();
    initializeImageUpload();
  });

  $(document).on('nested:fieldRemoved:images', function() {
    fieldsCount -= 1;
    toggleAddLink();
  });

  // count existing nested fields after page was loaded
  fieldsCount = $('form .fields:visible').length;
  toggleAddLink();
})
