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
		var firstName = $('#edit-first-name');
		var lastName = $('#edit-last-name');
		var userName = $('#edit-email');
		var phoneNumber = $('#edit-phone');


		if(firstName.val() == "" || lastName.val() == "" || userName.val() == "" || !roles.find("input[type='checkbox']").is(':checked')){
			if(firstName.val() == ""){
				validation(errorElement,'Please Enter First Name');
			}
			
			if(lastName.val() == ""){
				validation(errorElement,'Please Enter Last Name');
			}

			if(userName.val() == ""){
				validation(errorElement,'Please Enter User Name');
			}

			if(!roles.find("input[type='checkbox']").is(':checked')){
				validation(errorElement,'Please Select Atleast One Role');
			}
				return false;
		}
		else{
			
			var data = {
					'first_name' : firstName.val(),
					'last_name' : lastName.val(),
					'user_name' : userName.val(),
					'phone_number' : phoneNumber.val(),
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
