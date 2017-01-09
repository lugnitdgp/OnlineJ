$(document).on('turbolinks:load', function() {

  var cEditor = new CodeMirror(document.getElementById("code_editor"), {
    lineNumbers: true,
    extraKeys: null,
    mode: "text/x-c++src",
    lineWrapping: true,
    viewportMargin: Infinity,
    matchBrackets: true
  });
  height = $('.container-fluid').width();
  cEditor.setSize(height-2,400);
  cEditor.refresh();
  $('#mode').change(function(event) {
    cEditor.setOption("mode",event.val);
  });

  $('#theme li').click(function() {
    cEditor.setOption("theme",$(this).attr('value'));
  });
  $('#autocomplete').click(function(event) {
    event.stopPropagation();
  });
  $('.bootstrap-switch-label').click(function(event) {
    if( $('.bootstrap-switch').hasClass('bootstrap-switch-off') ) {
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
