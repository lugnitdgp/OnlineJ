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
        if( data['status_code'] == 'PE'){
          setTimeout( function(){
            get_submission_data(element)
          }, 5000);
        }
        else {
          img = '';
          status = '<figcaption>'+data['status_code']+'</figcaption>';
          if( data['error_desc'] && data['status_code'] == "RTE") {
            status = '<figcaption>'+data['error_desc']+'</figcaption>';
          }
          if( data['status_code'] == 'CE'){
            img = '<img src="/icons/CE.png" alt="CE" width="25" height="25" />';
          } else {
            img = '<img src="/icons/'+data['status_code']+'.png" alt='+data['status_code']+' width="23" height="23" />';
            console.log(img);
            $(element).next().text(data['time_taken'])
          }
          $(element).children().remove();
          $(element).append(img);
          $(element).append(status);
          $(element).attr('data-status',data['status_code']);
        }
      },
      error: function(data){
        console.log(data);
      },
      type: 'GET'
    });
  }
});
