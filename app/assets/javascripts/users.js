$(document).ready(function() {
	$("#username").blur(function(){
			console.log("Hey");
			username = $(this).val();
			$.ajax({
				type: "POST",
				url: "/users/checkuser",
				data: {"username": username},
				success: function(result){
					console.log(result);
					$('#status').html(result.status);
				}
			});
		});
});