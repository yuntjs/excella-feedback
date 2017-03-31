$(function () {
  //
  // Toggle chevron glyphicon when clicked
  //
  var changeGlyphicon = function changeGlyphicon($glyphicon) {
    if ($glyphicon.hasClass('glyphicon-chevron-right')) {
      $glyphicon.removeClass('glyphicon-chevron-right');
      $glyphicon.addClass('glyphicon-chevron-down');
    } else {
      $glyphicon.removeClass('glyphicon-chevron-down');
      $glyphicon.addClass('glyphicon-chevron-right');
    };
  };

  //
  // Toggle question template data when glyphicon is clicked
  // Change glyphicon
  // Show & hide question templates
  //
  $('.survey-template-presentation .glyphicon').on('click', function(e) {
    var templateId = $(e.target).data('id');
    var $glyphicon = $('.glyphicon[data-id=' + templateId + ']');
    var $questionTable = $('.question-table[data-id=' + templateId + ']');

    changeGlyphicon($glyphicon);
    $questionTable.toggle();
  }); 
});
