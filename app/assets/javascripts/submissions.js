$(document).ready(function() {
  $("time.timeago").timeago();
  $('.datatable-submission').DataTable({
     "bFilter": false,
     "bInfo": false,
     "bPaginate": false,
     "bAutoWidth": false,
     "bScrollCollapse": true,
     "fnInitComplete": function() {
        this.css("visibility", "visible");
      },
     "bLengthChange": false,
     "targets": 'no-sort', "bSort": false, "order": []
    });

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
        setTimeout( function(){
          get_submission_data(element)
        }, 5000);
      },
      type: 'GET'
    });
  }

  get_submission_button = $('.submission-btn').click(function(event) {
    submission_id = ($(this).children().attr('data-get-id'));
    user = $(this).siblings('.user').text();
    problem = $(this).siblings('.problem').text();
    $('#submission_modal .modal-title').text("Submission for "+problem)
    $('#submission_modal').modal();
    $.ajax({
      url: '/get_submission',
      data: {
        "submission_id": submission_id
      },
      dataType: 'json',
      success: function(data){
        lang = '<span>'+data['language']+'</span>'
        source_code = '<div>'+data['user_source_code']+'</div>'
        $('#submission_modal .modal-body').text("");
        $('#submission_modal .modal-body').append(lang);
        var cEditor = new CodeMirror(document.getElementById("code-body"), {
          lineNumbers: true,
          mode: data['lang_name'],
          lineWrapping: true,
          styleActiveLine: true,
          viewportMargin: Infinity,
          readOnly: true
        });
         cEditor.setValue(data['user_source_code']);
         setTimeout(function() {
           cEditor.refresh();
         }, 300);
      },
      error: function(data){
        $('#submission_modal .modal-body').text("");
        $('#submission_modal .modal-body').append("error loading");
      },
      type: 'GET'
    });
  });
});
