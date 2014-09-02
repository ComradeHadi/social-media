/********************************************
Author: Kevin Ponce
Contact: kevinponce88@gmail.com
Dependencies: jquery-2.1.1.min
Description: sets up homepage javascript
********************************************/
$.ajaxSetup({
  headers: {
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  }
});

var user = new User();
user.submit({
	target:'.login',
	redirect_url:'/posts/'
});
user.submit({
	target:'.signup',
	redirect_url:'/user/edit/'
});
user.keyupErrors();
user.emailChange();
user.userChange();