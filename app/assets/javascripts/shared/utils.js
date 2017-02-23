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
	if(confirmationType == "DeleteUser"){
		if(isModal){
			$(".delete-confirmation-modal-title").html("Delete User");
			$("#delete-confirmation-form").html("Are you sure, You want to delete User?");

			$("#delete-confirmation-modal").modal('show');
		}
		else{
			$("#delete-confirmation-modal").modal('hide');
		}
	}
	else if(confirmationType == "EditUser"){
		
	}
}	