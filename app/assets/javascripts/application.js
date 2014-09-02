$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});

//prevens user for searching when they have no entered anything
$(document).on('submit','.search_wrapper form',function(e){
	var _this = $(this);
	if(_this.find('.search_input').val() == ''){
		e.preventDefault();
		e.stopPropagation();
	}
});
