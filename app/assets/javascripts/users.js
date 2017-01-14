$(document).ready(function() {
	$(':input[type="submit"]').prop('disabled', true);
	$("#username").blur(function(){
			username = $(this).val();
			if(/^[a-zA-Z0-9_]*$/.test(username) == false) {
				$('#status').css({'background':'red','color':'white'});
    			$('#status').hide().html("No special characters and spaces allowed").fadeIn("slow");
    			$(':input[type="submit"]').prop('disabled', true);
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
						$(':input[type="submit"]').prop('disabled', false);
					}
					else{
						$('#status').css({'background':'red','color':'white'});
						$(':input[type="submit"]').prop('disabled', true);
					}
					$('#status').hide().html(result.status).fadeIn("slow");

				}
			});
		});
});