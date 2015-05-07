//$(function() {
//  function unifyHeights() {
//    var maxHeight = 0;
//    $('#chat-body').each(function() {
//      var height = $('#channel-interactive').height();
//      if ( height > maxHeight ) {
//        maxHeight = height;
//      }
//      $(this).css('height', maxHeight-100);
//      $(this).css('max-height', maxHeight-100);
//      $(this).scrollTop($(this).prop("scrollHeight"));
//    });
//  }
//  setTimeout(function(){
//    unifyHeights();
//  }, 250);
//});

(function($){
  $(window).load(function(){
    $("#chat-messages").mCustomScrollbar({
      theme: "minimal-dark",
      setHeight: 365 + $('#channel-online .description').height()
    });
  });
})(jQuery);
