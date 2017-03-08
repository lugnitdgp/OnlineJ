//= require bootstrap-sprockets
//= require google_analytics
//= require material.min
//= require material-kit


$(document).on('turbolinks:load', function() {
  $.timeago.settings.allowFuture = true;
  $("time.timeago").timeago();
  $("body").addClass('page-fade-only-init');

  setTimeout(function()
  {
    $('body').removeClass('page-fade-only-init page-fade-only');

  }, 500);

  // $('body').css({
  //   'font-family': '"Helvetica Neue", Helvetica, "Noto Sans", sans-serif',
  //   'font-size': '16px'
  // });

  $('.dropdown-toggle').dropdown();

});
