$(function(){
  window.codemirror_editors = {};
  $('.codemirror').each(function(){
    var $el = $(this);
    codemirror_editors[$el.attr('id')] = CodeMirror.fromTextArea($el[0],
      {
        lineNumbers: true,
        matchBrackets: true,
        mode: "text/x-csrc"
      });
  });
});
