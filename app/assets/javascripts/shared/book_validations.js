$(document).on('turbolinks:load',function(){

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