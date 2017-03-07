$(document).on('turbolinks:load',function(){

	var forgotPwdFormMsg = $('#forgot-password-form-message');
	var changePwdFormMsg = $('#change-password-form-message');
	var forgotPwdModal = $('#forgot-password-modal');

	//forgot password link
	$('#forgot-password-link').click(function() {
		forgotPwdFormMsg.empty();
		$('#email_address').val('');

		forgotPwdModal.modal('show');
	});

	//change password form submit
    $('#change-password-form').submit(function() {			
		changePwdFormMsg.empty();
		var newPassword = $('#user_new_password').val();
		var confirmPassword = $('#user_confirm_password').val();
		
		if(newPassword != confirmPassword) {
			changePwdFormMsg.html('New Password and Confirm Password does not match');
			return false;
		}			
	});	

    //forgot password button submit
	$('#forgot-password-btn-submit').click(function() {

		forgotPwdFormMsg.empty();
		var email = $('#email_address').val();

		if(email == null || email == "") {
			forgotPwdFormMsg.html('Please Enter Email Address');
		}
		else if(!emailRegex(email)) {
			forgotPwdFormMsg.html('Email Address format is not valid');
		}
		else {
			$.ajax({
				url: _forgotPasswordUrl,
				type: "POST",
				data: { 'email_address': email },
				dataType: "json"
			}).done(function(resp){
				if(resp.Error) {
					forgotPwdFormMsg.html('Error Occured...');
				}
				else {
					if(resp) {
						forgotPwdFormMsg.html('Mail has been sent successfully');
						setTimeout(function() {
							forgotPwdModal.modal('hide');
						},2000)	
					}
					else {
						forgotPwdFormMsg.html('Invalid Email Address');
					}									
				}
			});			
		}
	});
});