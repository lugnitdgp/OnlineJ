$(document).ready(function() {
	// $(':input[type="submit"]').prop('disabled', true);
	$("#username").keyup(function(){
			username = $(this).val();
			if(/^[a-zA-Z0-9_]*$/.test(username) == false || username.length < 2) {
    			$('#status').hide().html('<br/><br/><img src="/icons/WA.png" width="23" height="23" >').fadeIn("slow");
    			$(':input[type="submit"]').prop('disabled', true);
				return;
			}

			$.ajax({
				type: "POST",
				url: "/users/checkuser",
				data: {"username": username},
				success: function(result){
					if(result.status==='OK'){
						$(':input[type="submit"]').prop('disabled', false);
    					$('#status').hide().html('<br/><br/><img src="/icons/AC.png" width="23" height="23" >').fadeIn("slow");
					}
					else{
    					$('#status').hide().html('<br/><br/><img src="/icons/WA.png" width="23" height="23" >').fadeIn("slow");
						$(':input[type="submit"]').prop('disabled', true);
					}
				},
			});
		});
});
