$(function () {
  //
  // Bootstrap helper for a presentation's long description popover
  //
  $('[data-toggle="popover"]').popover()

  //
  // Event listener for participation form submission
  //
  $('#participation-form-submit').on('click', function() {
    $('#participation-form').submit()
  })
})
