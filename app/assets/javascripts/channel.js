$(function() {
  function unifyHeights() {
    var maxHeight = 0;
    $('#chat-body').each(function() {
      var height = $('#channel-interactive').height();
      if ( height > maxHeight ) {
        maxHeight = height;
      }
      $(this).css('height', maxHeight-100);
    });
  }
  setTimeout(function(){
    unifyHeights();
  }, 250);
});
