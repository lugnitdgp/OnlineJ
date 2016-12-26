$(document).on('turbolinks:load', function() {
  var cEditor = CodeMirror.fromTextArea(document.getElementById("page_body"), {
     lineNumbers: true,
     matchBrackets: true,
     mode: "text/x-csrc"
  });
  var mac = CodeMirror.keyMap.default == CodeMirror.keyMap.macDefault;
  CodeMirror.keyMap.default[(mac ? "Cmd" : "Ctrl") + "-Space"] = "autocomplete";
});
