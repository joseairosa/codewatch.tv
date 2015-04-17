$(function() {
  function unifyHeights() {
    var maxHeight = 0;
    $('#chat-body').each(function() {
      var height = $('#channel-interactive').height();
      if ( height > maxHeight ) {
        maxHeight = height;
      }
      $(this).css('height', maxHeight-100);
      $(this).css('max-height', maxHeight-100);
      $(this).scrollTop($(this).prop("scrollHeight"));
    });
  }
  setTimeout(function(){
    unifyHeights();
  }, 250);
});
