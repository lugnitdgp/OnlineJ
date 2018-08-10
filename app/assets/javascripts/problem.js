$(document).on('turbolinks:load', function() {
  mode = $('#mode').val();
  snippets = [];
  var cEditor = new CodeMirror(document.getElementById("code_editor"), {
    lineNumbers: true,
    extraKeys: null,
    mode: mode,
    lineWrapping: true,
    viewportMargin: Infinity,
    matchBrackets: true
    // extraKeys: {
    //     "F11": function(cm) {
    //       setFullScreen(cm, !isFullScreen(cm));
    //     },
    //     "Esc": function(cm) {
    //       if (isFullScreen(cm)) setFullScreen(cm, false);
    //     }
    //   }
  });
  height = $('.container-fluid').width();
  cEditor.setSize(height-2,400);
  if(gon.submission) {
    $('#mode').val(gon.lang_name)
    cEditor.setOption("mode",gon.lang_name);
    cEditor.setValue(gon.user_source_code);
  } else {
    var lang_code = $('#mode option:selected');
    $(lang_code).addClass('pre');
    fetch_snippets($(lang_code).text());
  }
  setTimeout(function() {
    cEditor.refresh();
  },1000);

  $('#mode').change(function(event) {
    var pre = $('#mode').find('.pre');
    var lang_code = $('#mode option:selected');
    cEditor.setOption("mode",$(this).val());
    snippets[$(pre).text()] = cEditor.getValue();
    if( snippets[$(lang_code).text()] == undefined) {
      fetch_snippets($(lang_code).text());
    } else {
      cEditor.setValue(snippets[$(lang_code).text()]);
    }
    $(pre).removeClass('pre');
    $(lang_code).addClass('pre');
    $('#default-lang').text("Set "+$(lang_code).text()+ " as default");
  });

  $('#theme li').click(function() {
    cEditor.setOption("theme",$(this).attr('value'));
  });
  $('#autocomplete').click(function(event) {
    event.stopPropagation();
  });
  $('#autocomplete input').change(function(event) {
    if($(this).is(":checked")){
        cEditor.setOption("extraKeys", {"Ctrl-Space": "autocomplete"});
      } else {
        cEditor.setOption("extraKeys", null);
      }
  });

$("#default-lang").click(function(event) {
  /* Act on the event */
    event.stopPropagation();
    var lang_code = $('#mode option:selected').text();
    $.ajax({
      url: "/users/set_lang/"+lang_code,
      success: function(data){
        if( data['status'] == 'OK') toastr['success'](lang_code+" is set as your default language");
        else if( data['status'] == 'SET') toastr['warning'](lang_code+" is already your default language");
        else toastr['error']('try again');
      },
      error: function(data) {
        toastr['error']('Cannot set please try again');
      },
      type: 'POST'
    });
});
  $('#submit_code').click(function(event) {
    var form = document.createElement('form');
    form.action = '/submit/'+gon.problem;
    form.method = 'post';
    var authenticity_token = document.createElement('input');
    authenticity_token.name = 'authenticity_token';
    authenticity_token.type = 'hidden';
    authenticity_token.value = $('meta[name=csrf-token]').attr('content');
    var user_source_code = document.createElement('textarea');
    user_source_code.name = 'user_source_code';
    user_source_code.value = cEditor.getValue();
    if (!user_source_code.value){
      console.log(user_source_code.value);
      toastr['warning']("code editor is empty");
      return;
    }
    var lang_name = document.createElement('input');
    lang_name.name ='lang_name';
    lang_name.value = cEditor.getOption('mode');
    // lang_name.value = $("#select2-chosen-1").text().toLowerCase();
    var ccode = document.createElement('input');
    ccode.name = 'ccode';
    ccode.value = gon.contest;
    var pcode = document.createElement('input');
    pcode.name = 'pcode';
    pcode.value = gon.problem;
    var test = document.createElement('input');
    test.name = 'test';
    test.value = gon.test;
    form.appendChild(authenticity_token);
    form.appendChild(user_source_code);
    form.appendChild(lang_name);
    form.appendChild(ccode);
    form.appendChild(pcode);
    form.appendChild(test);
    document.body.appendChild(form);
    form.style.visibility = 'hidden';
    form.submit();
  });

  $('.fetch_comments').click(function(event) {
    /* Act on the event */
    fetch_comments();
  });

  function fetch_snippets(lang_code) {
    $.ajax({
      url: "/get_snippet/"+lang_code,
      success: function(data){
        cEditor.setValue(data['snippet']);
      },
      error: function(data) {
        cEditor.setValue("")
      },
      type: 'GET'
    });
  }

  $('#code_history').click(function(event) {
    var lang_code = $('#mode option:selected').text();
    var pcode = gon.problem;
    $.ajax({
      url: '/code_history/'+pcode+'/'+lang_code,
      success: function(data) {
        console.log(data);
        $('#historyBody').html("");
        if(data.history.length == 0) {
          $('#historyBody').append('<h6>No Saved Codes</h6>');
        }
        else {
          var htmlStr = "<table class='table-striped' style='box-shadow: 0 0 0 0!important;'>"
          $.each(data.history, function(index, hash) {
            htmlStr += '<tr><td><h6>'+hash+"</h6></td><td onclick=\"change_code('"+hash+"')\"><h6>Restore</h6></td></tr>";
          });
          $('#historyBody').append(htmlStr);
      }
      }
    });
  });
});

function change_code(hash) {
  console.log(hash);
}

function fetch_comments() {
  ccode = gon.contest;
  pcode = gon.problem;
  $('.comments').html("loading...")
  $.ajax({
    url: "/comments/"+ccode+"/"+pcode,
    success: function(data){
      $('.fetch_comments').removeClass('fetch_comments');
      $('.comments').html(data);
    },
    error: function(data) {
      /* Act on the event */
      var d = "<p>Error loading Please reload the page and try again</p>"
      $('.comments').html(d);
    },
    type: 'GET'
  });
}
