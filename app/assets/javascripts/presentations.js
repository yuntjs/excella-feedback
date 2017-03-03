// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
  // Bootstrap helper for Presentation long Description popover
  $('[data-toggle="popover"]').popover()

  // Event listener for participation form submit
  $('#participation-form-submit').on('click', function() {
    $('#participation-form').submit()
  })
})
