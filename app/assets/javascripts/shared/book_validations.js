$(document).on('turbolinks:load',function(){

	var bookData =[];
	var fileUploadedData =[];
	var bookPageIds =[];
	var errorElement = $('#add-new-book-form-message');
	var booksGrid = $("#book-management-grid");
	var userGrid;
	var bookId =0;

	if(!booksGrid.hasClass("DataTable")) {
  		bookGrid = booksGrid.DataTable({
				  	sPaginationType: "full_numbers",
				  	bJQueryUI: true,
				  	bProcessing: true,
					bServerSide: true,
					sAjaxSource: $("#book-management-grid").data('source'),
					"columnDefs": [
							{
								"targets": [0,9,10,11,12],
								"visible": false,
								"searchable": false,
								"orderable":false
							},{
								"targets": [2,4,5,6,7,8],
								"searchable": false,
								"orderable":false
							}
					],
					'fnCreatedRow': function (nRow, aaData, iDataIndex) {
				         $(nRow).attr('id', 'BMRow_' + aaData[0]); // or whatever you choose to set as the id
				    }
		});		

	  	$('#book-management-grid_wrapper').addClass('datatable-format');
	}

	// ------------------------------------     File Upload        ------------------------------------------------ 
	var uploadMultipleFiles = false;
	var uploadFiles =$('#images-to-upload');
	var uploadFileElement = $('#edit-book-picture'); 
	var selectedOptionVal ='';

	$('#sel-page-type').on('change',function(){

		resetValidation(uploadFiles);
		uploadFileElement.val('');

		var selectedOption = $('#sel-page-type option:selected');
 		var bookUploadSection = $('#book-picture-section');
 		var selectedOptionIndex = selectedOption.index();

		bookUploadSection.prop('hidden', !(selectedOptionIndex !=0));

		if(bookUploadSection.is(':visible')){
			var indexArray =[1,2];

			uploadMultipleFiles = !($.inArray(selectedOptionIndex,indexArray) > -1);

			uploadFileElement.prop('multiple', uploadMultipleFiles);
			selectedOptionVal = selectedOption.val();
		}
	});

	$("input[type='file']").change(function(e){
		
		var renderData =[];

		if(!uploadMultipleFiles){
			resetValidation(uploadFiles);
		}
		var files = e.target.files;

		$.each(files,function(indx,file){
			
			var reader = new FileReader();
			reader.readAsDataURL(file);

			reader.onload = function(e){

				renderData.push(e.target.result);
				var template = '<img src="'+ e.target.result +'"style="width:50px;"> &nbsp;';
				uploadFiles.append(template);
				
				if((files.length == renderData.length) && selectedOptionVal != ""){
					
					var data ={
						'page_type': selectedOptionVal,
						'uploaded_images': renderData,
						'existing_ids': bookPageIds
					}

					$.ajax({
						url: _bookUploadImageUrl,
						type: "POST",
						data: data,
						dataType: "json"
					}).done(function(data){
						
						if(data!=null){
							if (data.result) {
								if(data.ids.length > 0) {
									bookPageIds = data.ids;
								}
							} else {
								validation(errorElement,'Error Occured...');
							}
						}
						else{
							validation(errorElement,'Error Occured...');
						}
					});
				}
			};
		});
	});

	$("#add-new-book-modal").on('hide.bs.modal',function(){
		
		if(bookPageIds.length > 0){
			$.ajax({
				url: _bookDeleteImageUrl,
				type: "POST",
				data: {'ids': bookPageIds},
				dataType: "json"
			}).done(function(result){
				if(result!=null){
					if (result) {
						bookPageIds = [];
					} else {
						validation(errorElement,'Error Occured...');
					}
				}
				else{
					validation(errorElement,'Error Occured...');
				}
			});
		}
	});

	// ------------------------------------     File Upload        ------------------------------------------------ 

	// ------------------------------------     Book Management    ------------------------------------------------ 

	var bookname = $('#edit-book-name');
	var description = $('#edit-description');
	var author = $('#edit-author');
	var edition = $('#edit-edition');
	var publication = $('#edit-publication');
	var yearpublish = $('#edit-year-publish');

	// to know whether a new book is added or updating existing book.
	var isNewBook = true;

	$('#add-new-book').click(function(e){
		
		isNewBook = true;
  		resetValidation(errorElement);
  		resetValidation(uploadFiles);

  		$('#sel-page-type option')[0].selected = true;
  		$('#sel-page-type').trigger('change');
  		$('#edit-book-name, #edit-book-picture, #edit-description, #edit-author, #edit-edition, #edit-publication, #edit-year-publish, #edit-upload-index').val('');

		$('#book-page-type-section').prop('hidden',false);
  		confirmationBox("AddBook",true);
	});

	// Update Book
	$(document).on('click','.editBook',function(e){
		
		e.preventDefault();

		isNewBook = false;
		resetValidation(errorElement);
		bookData = $(this).parents('tr');
		var data = bookGrid.row(bookData).data();

		if(data != null){
			bookId = data[0];
			bookname.val(data[1]);
			description.val(data[3]);
			author.val(data[9]);
			edition.val(data[10]);
		 	publication.val(data[11]);
		 	yearpublish.val(data[12]);
		}

		$('#book-page-type-section,#book-picture-section').prop('hidden',true);
		confirmationBox("EditBook",true);
		bookPageIds = [];
	});

	$('#btn_save_new_book').click(function(e){
				
		resetValidation(errorElement);

		if(bookname.val() == "" || description.val() == ""){
			if(bookname.val() == ""){
				validation(errorElement,'Please Enter Book Name');
			}
			if(description.val() == ""){
				validation(errorElement,'Please Enter Description');
			}	
			if(yearpublish.val() != "" && !phoneNoRegex(yearpublish.val())) {
			validation(errorElement,'Publication Year accepts digits only');
			}		
		}
		else{
			
			var data = {
					'book_name' : bookname.val(),
					'description' : description.val(),
					'author_name' : author.val(),
					'edition' : edition.val(),
					'publication_name' : publication.val(),
					'publication_year' : yearpublish.val(),
					'book_page_ids': bookPageIds,
					'is_new_book': isNewBook
			}; 

			if (!isNewBook) {
				data['book_id'] = bookId;
			}

			$.ajax({
				url:_booksAddUrl,
				type: "POST",
				data: data,
				dataType: "json"
			}).done(function(data){
				if(data != null){
					if(data){
						confirmationBox("AddBook",false);
						bookPageIds = [];
						window.location = _booksIndexUrl;
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

	// Delete Book
	$(document).on('click','.deleteBook',function(e){
		
		e.preventDefault();
		bookData = $(this).parents('tr');

		confirmationBox("DeleteBook",true);
	});

	$("#btn-delete-confirmation").click(function(){

		if ($(".delete-confirmation-modal-title").html().includes('Book')) {
			var id = bookData.attr('id').split('_')[1];
			data = {"id": id}
			fnConfirmation(data,_booksDeleteUrl,_booksIndexUrl,"DeleteBook");
		}
	});

	// ------------------------------------     Book Management    ------------------------------------------------ 

	// ------------------------------------     Book Subscription    ---------------------------------------------- 
	$(document).on('click','.subscribeBook',function(e){
		
		e.preventDefault();
		bookData = $(this).parents('tr');

		confirmationBox("SubscribeBook",true);
	});

	$("#btn-book-subscribe").click(function(){
		
		var id = bookData.attr('id').split('_')[1];
		data = {'book_id': id};

		fnConfirmation(data,_bookSubscribeUrl,_booksIndexUrl,"SubscribeBook");
	});

	// ------------------------------------     Book Subscription    ---------------------------------------------- 

	// ------------------------------------     Activity Logs    -------------------------------------------------- 
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

	// ------------------------------------     Activity Logs     -------------------------------------------------- 
});