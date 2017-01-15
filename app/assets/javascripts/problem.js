$(document).on('turbolinks:load', function() {
  mode = $('#mode').val();
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
  cEditor.refresh();
  $('#mode').change(function(event) {
    cEditor.setOption("mode",$(this).val());
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

  $('#submit_code').click(function(event) {
    var form = document.createElement('form');
    form.action = '/submit/'+window._problem;
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
    ccode.value = window._contest;
    var pcode = document.createElement('input');
    pcode.name = 'pcode';
    pcode.value = window._problem;
    form.appendChild(authenticity_token);
    form.appendChild(user_source_code);
    form.appendChild(lang_name);
    form.appendChild(ccode);
    form.appendChild(pcode);
    document.body.appendChild(form);
    form.style.visibility = 'hidden';
    form.submit();
  });
});
