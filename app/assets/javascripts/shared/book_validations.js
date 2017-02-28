$(document).on('turbolinks:load',function(){

	var errorElement = $('#add-new-book-form-message');

	if(!$( "#book_management_grid" ).hasClass("DataTable")) {
  		$('#book_management_grid').DataTable({
		  	sPaginationType: "full_numbers",
		  	bJQueryUI: true
		});		
	  	$('#book_management_grid_wrapper').addClass('datatable-format');
	}

	$('#add-new-book').click(function(e){

  		resetValidation(errorElement);

  		$('#edit-book-name, #edit-book-picture, #edit-description, #edit-author, #edit-edition, #edit-publication, #edit-year-publish, #edit-upload-index').val('');

  		confirmationBox("AddBook",true);
	});

	$('#btn_save_new_book').click(function(e){
				
		resetValidation(errorElement);

		var bookname = $('#edit-book-name');
		// var bookpicture = $('#edit-book-picture');
		var description = $('#edit-description');
		var author = $('#edit-author');
		var edition = $('#edit-edition');
		var publication = $('#edit-publication');
		var yearpublish = $('#edit-year-publish');
		// var uploadindex = $('#edit-upload-index');

		if(bookname.val() == "" /*|| bookpicture.val() == ""*/ || description.val() == "" || author.val() == "" || edition.val() == "" || publication.val() == "" || yearpublish.val() == "" /*|| uploadindex.val() == "" */){
			if(bookname.val() == ""){
				validation(errorElement,'Please Enter Book Name');
			}
			
			/*f(bookpicture.val() == ""){
				validation(errorElement,'Upload Book Picture');
			}*/

			if(description.val() == ""){
				validation(errorElement,'Please Enter Description');
			}
			if(author.val() == ""){
				validation(errorElement,'Please Enter Author');
			}
			
			if(edition.val() == ""){
				validation(errorElement,'Please Enter Edition');
			}

			if(publication.val() == ""){
				validation(errorElement,'Please Enter Publication');
			}
			if(yearpublish.val() == ""){
				validation(errorElement,'Please Enter Publish year');
			}

			/*if(uploadindex.val() == ""){
				validation(errorElement,'Upload index');
			}*/
		}
		else{
			
			var data = {
					'book_name' : bookname.val(),
					/*'' : bookpicture.val(),*/
					'description' : description.val(),
					'author_name' : author.val(),
					'edition' : edition.val(),
					'publication_name' : publication.val(),
					'publication_year' : yearpublish.val(),
					/*'' : uploadindex.val()*/
			}; 

			$.ajax({
				url:"/books/add",
				type: "POST",
				data: data,
				dataType: "json"
			}).done(function(data){
				
				if(data != null){
					if(data){
						confirmationBox("AddBook",false);
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

	var activityLogsGrid = $("#activity_logs_grid");

	//activity logs grid
	if(!activityLogsGrid.hasClass("dataTable")) {

  		activityLogsGrid.dataTable({
		  	sPaginationType: "full_numbers",
		  	bJQueryUI: true,		  	
		  	bProcessing: true,
    		bServerSide: true,
    		sAjaxSource: $('#activity_logs_grid').data('source')
		});	

	  	$('#activity_logs_grid_wrapper').addClass('datatable-format')
	}	
});

