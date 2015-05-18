$(function(){
  $(document).on('ajax:complete', function (event, response) {
    var element = $($(this)['context'].activeElement);
    switch ($(this)['context'].activeElement.id) {
      case 'ajax-like-channel':
        if (response.status == 200) {
          var old_counter = parseInt($('.likes #does-not-likes-channel .counter').html());
          $('#likes-channel .counter').html(old_counter + 1);
          $('#does-not-likes-channel .counter').html(old_counter + 1);
          $('#likes-channel').removeClass('hide');
          $('#does-not-likes-channel').addClass('hide');
        }
        break;
      case 'ajax-unlike-channel':
        if (response.status == 200) {
          var old_counter = parseInt($('.likes #does-not-likes-channel .counter').html());
          $('#likes-channel .counter').html(old_counter - 1);
          $('#does-not-likes-channel .counter').html(old_counter - 1);
          $('#likes-channel').addClass('hide');
          $('#does-not-likes-channel').removeClass('hide');
        }
        break;
    }
  });
});
