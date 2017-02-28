$(document).on('turbolinks:load',function(){
	var userData =[];
	var errorElement = $('#add-new-user-form-message');
	var usersGrid = $("#users-grid");
	var userGrid;
	var userId = 0;

	if(!usersGrid.hasClass("DataTable")) {

  		userGrid = 	usersGrid.DataTable({
			  		sPaginationType: "full_numbers",
			  		bJQueryUI: true,		  	
			  		bProcessing: true,
					bServerSide: true,
					sAjaxSource: $('#users-grid').data('source'),
					"columnDefs": [
							{
								"targets": [0,6,7,8,9,10],
								"searchable": false,
								"orderable":false,
								"visible":false
							},{
								"targets": [4,5],
								"searchable": false,
								"orderable":false
							}
					],
					'fnCreatedRow': function (nRow, aaData, iDataIndex) {
				         $(nRow).attr('id', 'DURow_' + aaData[0]); // or whatever you choose to set as the id
				    }
		});

	  	$('#users-grid_wrapper').addClass('datatable-format');
	}

	var roles = $('#RoleTypes-section');
	var firstName = $('#edit-first-name');
	var lastName = $('#edit-last-name');
	var emailAddress = $('#edit-email');
	var phoneNumber = $('#edit-phone');
	var adminRole = $('#edit-add-adminRole');
	var librarianRole = $('#edit-add-librarianRole');
	var userRole = $('#edit-add-userRole');
	var isCreateEditUser = false;
	var isExistsAdminRole = isExistsLibrarianRole = isExistsUserRole = false;

	// Add User
	$('#add-new-user').click(function(e){
  		isCreateEditUser = false;
  		resetValidation(errorElement);

  		$('#edit-first-name,#edit-last-name,#edit-email,#edit-phone').val('');

  		var roletypes = $('#RoleTypes-section');
  		if(roletypes.find("input[type='checkbox']").is(":checked")){
  			roletypes.find("input[type='checkbox']:checked").removeAttr("checked");
  		}

  		confirmationBox("CreateUser",true);
	});

	$('#btn_save_new_user').click(function(e){
		
		resetValidation(errorElement);

		var hasErrors = false;

		if(firstName.val() == ""){
			hasErrors = true;
			validation(errorElement,'Please Enter First Name');
		}			
		if(lastName.val() == ""){
			hasErrors = true;
			validation(errorElement,'Please Enter Last Name');
		}
		if(emailAddress.val() == ""){
			hasErrors = true;
			validation(errorElement,'Please Enter Email Address');
		}
		if(emailAddress.val() != "" && (!emailRegex(emailAddress.val()) || _emailDomains.indexOf(emailAddress.val().split('@')[1]) == -1)) {
			hasErrors = true;
			validation(errorElement,'Email Address format is not valid');
		}
		if(phoneNumber.val() != "" && !phoneNoRegex(phoneNumber.val())) {
			hasErrors = true;
			validation(errorElement,'Phone Number accepts digits only');
		}
		if(!roles.find("input[type='checkbox']").is(':checked')){
			hasErrors = true;
			validation(errorElement,'Please select atleast one Role');
		}			
		if(!hasErrors) {
			
			var data = {
					'first_name' : firstName.val(),
					'last_name' : lastName.val(),
					'email_address' : emailAddress.val(),
					'phone_number' : phoneNumber.val(),
					'has_admin_role' : adminRole.is(":checked"),
					'has_librarian_role' : librarianRole.is(":checked"),
					'has_user_role' : userRole.is(":checked"),
					'is_edit_user': isCreateEditUser					
			}; 

			if(isCreateEditUser){
				
				data['user_id'] = userId;
				data['is_exist_admin_role'] = isExistsAdminRole;
				data['is_exist_librarian_role'] = isExistsLibrarianRole;
				data['is_exist_user_role'] = isExistsUserRole;
			}

			$.ajax({
				url: _usersAddOrUpdateUrl,
				type: "POST",
				data: data,
				dataType: "json"
			}).done(function(data){
				
				if(data != null){
					if(data){
						confirmationBox("CreateUser",false);
						window.location = _usersIndexUrl;
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

	// Delete User
	$(document).on('click','.deleteUser',function(e){
		
		e.preventDefault();
		userData = $(this).parents('tr');

		confirmationBox("DeleteUser",true);
	});

	$("#btn-delete-confirmation").click(function(){
		
		var id = userData.attr('id').split('_')[1];

		$.ajax({
			url: _usersDeleteUrl,
			type: "POST",
			data: {"id": id},
			dataType: "json"
		}).done(function(data){
			
			if(data != null){
				if(data){
					confirmationBox("DeleteUser",false);
					window.location = _usersIndexUrl;
				}
				else{
					validation(errorElement,'Error Occured...');
				}
			}
			else{
				validation(errorElement,'Error Occured...');
			}
		});
	});

	// Update User
	$(document).on('click','.editUser',function(e){
		
		e.preventDefault();
		userData = $(this).parents('tr');
		var data = userGrid.row(userData).data();
		
		isCreateEditUser = true;
		resetValidation(errorElement);

		if(data != null){
			firstName.val(data[6]);
			lastName.val(data[7]);
			emailAddress.val(data[2]);
			phoneNumber.val(data[3]);
			userId = data[0];

			isExistsAdminRole = data[8].includes("is_Admin");
			isExistsLibrarianRole = data[9].includes("is_Librarian");
			isExistsUserRole = data[10].includes("is_User");

			isCheckedAttr(adminRole,isExistsAdminRole);
			isCheckedAttr(librarianRole,isExistsLibrarianRole);
			isCheckedAttr(userRole,isExistsUserRole);
		}
		confirmationBox("EditUser",true);
	});

});
