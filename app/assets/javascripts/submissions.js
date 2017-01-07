$(document).ready(function() {
  $("time.timeago").timeago();
  $('[data-status="PE"]').each(function(index, el) {
    get_submission_data(el)
  });

  function get_submission_data(element) {
    submission_id = element.getAttribute('data-id')
    $.ajax({
      url: '/get_submission_data',
      data: {
        "submission_id": submission_id
      },
      dataType: 'json',
      success: function(data){
        console.log(data)
        if( data['status_code'] == 'PE'){
          setTimeout( function(){
            get_submission_data(element)
          }, 5000);
        }
        else {
          $(element).text(data['status_code'])
        }
      },
      error: function(data){
        console.log(data);
      },
      type: 'GET'
    });
  }
});
