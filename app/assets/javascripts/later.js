//= require bootstrap-sprockets
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
  
  toastr.options = {
    "closeButton": true,
    "debug": false,
    "newestOnTop": true,
    "progressBar": true,
    "positionClass": "toast-top-right",
    "preventDuplicates": true,
    "onclick": null,
    "showDuration": "300",
    "hideDuration": "1000",
    "timeOut": "5000",
    "extendedTimeOut": "1000",
    "showEasing": "swing",
    "hideEasing": "linear",
    "showMethod": "fadeIn",
    "hideMethod": "fadeOut"
  }
});
