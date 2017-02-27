function validation(el,errorMsg){
	if(!el.find('ul').length > 0){
		el.append('<ul></ul>');
	}

	el.find('ul').append('<li>'+ errorMsg +'</li>');
}

function resetValidation(el){
	el.empty();
}

function confirmationBox(confirmationType,isModal){

	var createUser = (confirmationType == "CreateUser");
	var editUser = (confirmationType == "EditUser");

	if(createUser || editUser){
		if(isModal){
			$(".add-new-user-modal-title").html( (createUser ? "Create " : "Edit ") + "User");
			$("#add-new-user-modal").modal('show');
		}
		else{
			$("#add-new-user-modal").modal('hide');
		}
	}
	else if(confirmationType == "DeleteUser"){
		if(isModal){

			$(".delete-confirmation-modal-title").html("Delete User");
			$("#delete-confirmation-form").html("Are you sure, You want to delete User?");
			$("#delete-confirmation-modal").modal('show');
		}
		else{
			$("#delete-confirmation-modal").modal('hide');
		}
	}
}

function isCheckedAttr(el, is_checked){
	is_checked ? el.attr('checked','checked') : el.removeAttr('checked');
}	
