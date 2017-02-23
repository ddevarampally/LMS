$(document).on('turbolinks:load',function(){

	var errorElement = $('#add-new-user-form-message');
	var userModal = $('#add-new-user-modal');

	if(!$( "#users_grid" ).hasClass("dataTable")) {
  		$('#users_grid').dataTable({
		  	sPaginationType: "full_numbers",
		  	bJQueryUI: true
		});		
	  	$('#users_grid_wrapper').addClass('datatable-format');
	}

	$('#add-new-user').click(function(e){

  		resetValidation(errorElement);

  		$('#edit-first-name,#edit-last-name,#edit-email,#edit-phone').val('');

  		var roletypes = $('#RoleTypes-section');
  		if(roletypes.find("input[type='checkbox']").is(":checked")){
  			roletypes.find("input[type='checkbox']:checked").removeAttr("checked");
  		}

  		userModal.modal('show');
	});

	$('#btn_save_new_user').click(function(e){
				
		resetValidation(errorElement);

		var roles = $('#RoleTypes-section');
		var firstName = $('#edit-first-name').val();
		var lastName = $('#edit-last-name').val();
		var userName = $('#edit-email').val();
		var phoneNumber = $('#edit-phone').val();
		var phoneRegex = /^[0-9]+$/;

		var hasErrors = false;

		if(firstName == ""){
			hasErrors = true;
			validation(errorElement,'Please Enter First Name');
		}			
		if(lastName == ""){
			hasErrors = true;
			validation(errorElement,'Please Enter Last Name');
		}
		if(userName == ""){
			hasErrors = true;
			validation(errorElement,'Please Enter User Name');
		}
		if(phoneNumber != "" && !phoneRegex.test(phoneNumber)) {
			hasErrors = true;
			validation(errorElement,'Phone Number accepts digits only');
		}
		if(!roles.find("input[type='checkbox']").is(':checked')){
			hasErrors = true;
			validation(errorElement,'Please select atleast one Role');
		}			
		if(!hasErrors) {
			var data = {
				'first_name' : firstName,
				'last_name' : lastName,
				'user_name' : userName,
				'phone_number' : phoneNumber,
				'has_admin_role' : $('#edit-add-adminRole').is(":checked"),
				'has_librarian_role' : $('#edit-add-librarianRole').is(":checked"),
				'has_user_role' : $('#edit-add-userRole').is(":checked")
			}; 

			$.ajax({
				url:"/users/add",
				type: "POST",
				data: data,
				dataType: "json"
			}).done(function(data){
				
				if(data != null){
					if(data){
						userModal.modal('hide');
					}
					else{
						validation(errorElement,'Error Occured...');
					}
				}
				else{
					validation(errorElement,'Error Occured...');
				}				
			});
		}
	});
});


function validation(el,errorMsg){
	if(!el.find('ul').length > 0){
		el.append('<ul></ul>');
	}

	el.find('ul').append('<li>'+ errorMsg +'</li>');
}

function resetValidation(el){
	el.empty();
}
