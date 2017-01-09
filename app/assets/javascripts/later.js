//= require bootstrap-sprockets
//= require flat-ui
//= require local
//= require rippler


$(document).on('turbolinks:load', function() {
  $('.datatable').DataTable({
     "bFilter": false,
     "bInfo": false,
     "bPaginate": false,
     "bAutoWidth": false,
     "bScrollCollapse": true,
     "fnInitComplete": function() {
        this.css("visibility", "visible");
      },
     "bLengthChange": false,
    });

    $("body").addClass('page-fade-only-init')

    setTimeout(function()
    {
      $('body').removeClass('page-fade-only-init page-fade-only');

    }, 500);

  $(".rippler").rippler({
    effectClass      :  'rippler-effect'
    ,effectSize      :  16      // Default size (width & height)
    ,addElement      :  'div'   // e.g. 'svg'(feature)
    ,duration        :  400
  });
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
