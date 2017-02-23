$(document).on('turbolinks:load',function(){

	var userData =[];
	var errorElement = $('#add-new-user-form-message');
	var userModal = $('#add-new-user-modal');
	var usersGrid = $("#users-grid");
	var userGrid;

	if(!usersGrid.hasClass("DataTable")) {

  		userGrid = 	usersGrid.DataTable({
			  		sPaginationType: "full_numbers",
			  		bJQueryUI: true,		  	
			  		bProcessing: true,
					bServerSide: true,
					sAjaxSource: $('#users-grid').data('source'),
					"columnDefs": [
							{
								"targets": [-1],
								"data": null,
								"defaultContent": "<a href='#' class='grid-link-btn editUser'>Edit</a> | <a href='#' class='grid-link-btn deleteUser'>Delete</a>",
								"searchable": false,
								"orderable":false
							},{
								"targets": [-2],
								"searchable": false,
								"orderable":false
							}
					],
					"order": [[0, "asc"]],
					'fnCreatedRow': function (nRow, aaData, iDataIndex) {
				         $(nRow).attr('id', 'DURow_' + aaData[4]); // or whatever you choose to set as the id
				    }
		});

	  	$('#users-grid_wrapper').addClass('datatable-format');
	}

	// Add User
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

	// Delete User
	$(document).on('click','.deleteUser',function(e){
		
		e.preventDefault();
		userData = $(this).parents('tr');

		confirmationBox("DeleteUser",true);
	});

	$("#btn-delete-confirmation").click(function(){

		var id = userData.attr('id');

		$.ajax({
				url:"/users/delete",
				type: "POST",
				data: {"id": id.substring(id.length-2)},
				dataType: "json"
			}).done(function(data){
				
				if(data != null){
					if(data){
						confirmationBox("DeleteUser",false);
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

		confirmationBox("EditUser",true);
	});

});