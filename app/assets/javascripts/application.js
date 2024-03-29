// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui.min
//= require jquery_ujs
//= require jquery-migrate.min
//= require jquery.autocomplete.min
//= require bootstrap.min
//= require back-to-top
//= require jquery.parallax
//= require waypoints.min
//= require jquery.counterup.min
//= require owl.carousel
//= require socket.io
//= require jquery.mCustomScrollbar.concat.min
//= require chat
//= require search
//= require dashboard
//= require jwplayer/jwplayer
//= require typeahead.bundle.min
//= require tinymce-jquery
//= require datepicker
//= require main
//= require owl-carousel
//= require jquery.cubeportfolio.min
//= require cube-portfolio-6-fw-tx
//= require cookies_eu
//= require_tree .

jwplayer.key="XTCcJRRNCWLv6ALSFlA9oLGwf905fL80tNwAQg==";

function guid() {
  function s4() {
    return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
  }
  return s4() + s4() + '-' + s4() + '-' + s4() + '-' +  s4() + '-' + s4() + s4() + s4();
}

function add_alert(type, message) {
  var alert_id = "alert_"+guid();
  $('#alerts-wrapper').append('<div id="'+alert_id+'" class="alert alert-'+type+' fade in alert-dismissable text-center">'+message+'</div>');
  callback = function() { $('#' + alert_id).remove() };
  setTimeout(callback, 5000);
}

jQuery(document).ready(function() {
  App.init();
  //App.initCounter();
  App.initParallaxBg();
  OwlCarousel.initOwlCarousel();
  Datepicker.initDatepicker();

  setTimeout(function(){$('#alerts-wrapper .alert').fadeOut()}, 5000);
});
