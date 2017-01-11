
CKEDITOR.editorConfig = function( config ) {
    config.language = 'en';
    config.width = '90%';
    config.toolbarGroups = [
		{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
		{ name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
		{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
		{ name: 'forms', groups: [ 'forms' ] },
		'/',
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
		{ name: 'links', groups: [ 'links' ] },
		{ name: 'insert', groups: [ 'insert' ] },
		'/',
		{ name: 'styles', groups: [ 'styles' ] },
		{ name: 'colors', groups: [ 'colors' ] },
		{ name: 'tools', groups: [ 'tools' ] },
		{ name: 'others', groups: [ 'others' ] },
		{ name: 'about', groups: [ 'about' ] }
	];

	config.removeButtons = 'CopyFormatting,RemoveFormat,Strike,Form,Scayt,SelectAll,Find,Replace,Redo,Undo,Cut,Templates,Copy,Paste,PasteText,PasteFromWord,Button,Select,Textarea,TextField,Radio,Checkbox,HiddenField,ImageButton,BidiLtr,BidiRtl,Language,Anchor,Flash,PageBreak,About,Source,Save,NewPage,Preview,Print';
};