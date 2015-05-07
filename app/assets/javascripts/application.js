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
//= require chat
//= require search
//= require jwplayer/jwplayer
//= require typeahead.bundle.min
//= require tinymce-jquery
//= require main
//= require owl-carousel
//= require jquery.cubeportfolio.min
//= require jquery.mCustomScrollbar.concat.min
//= require cube-portfolio-6-fw-tx
//= require_tree .

jwplayer.key="RdBgRDffK8CxoR+GCaOb0iinIDch8TJmzRxvoA==";

function guid() {
  function s4() {
    return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
  }
  return s4() + s4() + '-' + s4() + '-' + s4() + '-' +  s4() + '-' + s4() + s4() + s4();
}

jQuery(document).ready(function() {
  App.init();
  App.initCounter();
  App.initParallaxBg();
  OwlCarousel.initOwlCarousel();
});

