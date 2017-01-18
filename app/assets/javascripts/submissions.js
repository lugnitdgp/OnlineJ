// $(document).on('turbolinks:load', function() {
$(document).ready(function() {
    $('[data-status="PE"]').each(function(index, el) {
    get_submission_data(el)
  });

  function get_submission_data(element) {
    submission_id = element.getAttribute('data-id')
    console.log();
    $.ajax({
      url: '/get_submission_data',
      data: {
        "submission_id": submission_id
      },
      dataType: 'json',
      success: function(data){
        if( data['status_code'] == 'PE'){
          $(element).children('figcaption').text(data['pe_status']);
          setTimeout( function(){
            get_submission_data(element)
          }, 3000);
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

  $('.submission-btn').click(function(event) {
    if ( $(this).children().hasClass('disabled')) {
      return;
    }
    submission_id = ($(this).children().attr('data-get-id'));
    user = $(this).siblings('.user').text();
    problem = $(this).siblings('.problem').text();
    status = $(this).siblings('.submission_status').text();
    $('#submission_modal .modal-title').text(user+" submission for "+problem)
    $('#submission_modal').modal();
    $.ajax({
      url: '/get_submission',
      data: {
        "submission_id": submission_id
      },
      dataType: 'json',
      success: function(data){
        lang = '<span>language: '+data['language']+'</span> <hr class="sm-divider">'
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
        $('#code-body').append('<hr class="sm-divider">')
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

  $('.submission_status').click(function(event) {
    if ( $(this).children().hasClass('disabled')) {
      return;
    }
    submission_id = $(this).attr('data-id');
    status = $(this).attr('data-status');
    problem = $(this).siblings('.problem').text();
    if (status == 'CE'){
      $('#submission_modal .modal-title').text("compilation error for "+ problem)
      $('#submission_modal').modal();
      $.ajax({
        url: '/get_submission_error',
        data: {
          "submission_id": submission_id
        },
        dataType: 'json',
        success: function(data){
          $('#submission_modal .modal-body').text("");
          var cEditor = new CodeMirror(document.getElementById("code-body"), {
            lineNumbers: true,
            mode: 'text/plain',
            lineWrapping: true,
            styleActiveLine: true,
            viewportMargin: Infinity,
            readOnly: true
          });
           cEditor.setValue(data['error_desc']);
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
    }
  });
});
