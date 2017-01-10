$(document).ready(function() {
	$("#username").blur(function(){
			username = $(this).val();
			if(/^[a-zA-Z0-9- ]*$/.test(username) == false) {
				$('#status').css({'background':'red','color':'white'});
    			$('#status').hide().html("No special characters allow except").fadeIn("slow");
				return;
			}

			$.ajax({
				type: "POST",
				url: "/users/checkuser",
				data: {"username": username},
				success: function(result){
					console.log(result);
					if(result.status==='OK You can go with that'){
						$('#status').css({'background':'green','color':'white','padding':'5px'});
					}
					else{
						$('#status').css({'background':'red','color':'white'});
					}
					$('#status').hide().html(result.status).fadeIn("slow");

				}
			});
		});
});