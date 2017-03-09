var _emailDomains = ['capspayroll.com', 'castandcrew.com'];

//route urls
var _forgotPasswordUrl = "/home/forgot_password";

var _usersIndexUrl = "/users/index";
var _usersAddOrUpdateUrl = "/users/add";
var _usersDeleteUrl = "/users/delete";

var _booksIndexUrl = "/books/index";
var _booksAddUrl = "/books/add";
var _booksDeleteUrl = "/books/delete";
var _bookSubscribeUrl = "/books/subscribe";
var _bookUploadImageUrl = "/books/image_upload";
var _bookDeleteImageUrl = "/books/delete_uploaded_images";

$(document).on('turbolinks:load',function(){

	//elements which should not allow space
	$('#user_user_name, #user_password, #user_current_password, #user_new_password, #user_confirm_password').on('keypress', function(e) {
		if (e.which == 32) {	//don't allow space
	    	return false;
		}
	});

	//elements which should not allow enter key
	$('#email_address').on('keypress', function(e) {
		if (e.which == 13) {	//if enter key pressed        	
	    	return false;
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

function confirmationBox(confirmationType,isModal){
	
	var createUser = "CreateUser";
	var editUser = "EditUser";
	var addBook = "AddBook";
	var editBook = "EditBook";

	var isCreateUser = (confirmationType == createUser);
	var isEditUser = (confirmationType == editUser);
	var isAddBook =(confirmationType == addBook);
	var isEditBook =(confirmationType == editBook);

	var deleteModalForm = $("#delete-confirmation-form");
	var deleteModalTitle = $(".delete-confirmation-modal-title");

	if(isCreateUser || isEditUser){
		if(isModal){
			$(".add-new-user-modal-title").html( (isCreateUser ? "Create " : "Edit ") + "User");
		}
		$("#add-new-user-modal").modal(isModal ? 'show' : 'hide');
	}
	else if(confirmationType == "DeleteUser"){
		fnModalPopUp($("#delete-confirmation-modal"),deleteModalTitle,deleteModalForm,"Delete User","Are you sure, You want to delete User....",isModal);
		resetValidation($("#delete-confirm-modal-message"));
	}
	else if(isAddBook || isEditBook){
		if(isModal){
			$(".add-new-book-modal-title").html( (isAddBook ? "Add " : "Edit ") + "Book");
		}
		$("#add-new-book-modal").modal(isModal ? 'show' : 'hide');
	}
	else if(confirmationType == "DeleteBook"){
		fnModalPopUp($("#delete-confirmation-modal"),deleteModalTitle,deleteModalForm,"Delete Book","Are you sure, You want to delete Book....",isModal);
		resetValidation($("#delete-confirm-modal-message"));
	}
	else if(confirmationType == "SubscribeBook"){
		fnModalPopUp($("#book-subscribe-modal"),$('.book-subscribe-modal-title'),$("#book-subscribe-form"),"Subscribe Book","You will be Notified, when book is available... ",isModal);
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

function fnConfirmation(data,postUrl,navigateUrl,title){

	$.ajax({
		url: postUrl,
		type: "POST",
		data: data,
		dataType: "json"
	}).done(function(data){
		
		if(data != null){
			if(data == true || data == "Success"){
				confirmationBox(title,false);
				window.location = navigateUrl;
			}			
			else if(data == false){
				$("#delete-confirm-modal-message").html("Error Occured...");
			}
			else {
				$("#delete-confirm-modal-message").html(data);
			}
		}
		else{
			$("#delete-confirm-modal-message").html("Error Occured...");
		}
	});
}

function fnModalPopUp(el,title,form,titleText,formText,isModalOpened){
	if(isModalOpened){
			title.html(titleText);
			form.html(formText);
		}
	el.modal(isModalOpened ? 'show' : 'hide');
}