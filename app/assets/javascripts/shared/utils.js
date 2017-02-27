var _emailDomains = ['capspayroll.com', 'castandcrew.com'];

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
	is_checked ? el.prop('checked', true) : el.removeAttr('checked');
}	

function emailRegex(value) {
	var pattern = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}$/;
	if(pattern.test(value)) {
		return true;
	}
	return false;
}

function phoneNoRegex(value) {
	var pattern = /^[0-9]+$/;
	if(pattern.test(value)) {
		return true;
	}
	return false;
}