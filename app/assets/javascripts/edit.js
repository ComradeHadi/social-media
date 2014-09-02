/********************************************
Author: Kevin Ponce
Contact: kevinponce88@gmail.com
Dependencies: jquery-2.1.1.min
Description: sets up edit javascript
********************************************/
var user = new User();

user.submit({
	target:'.edit',
	redirect_url:'#',
	empty:['Password'],
	message_target:'.signup_message'
});
user.keyupErrors();
user.emailChange();
user.userChange();



$(document).on('change','#photoimg',function()			{
           //$("#preview").html('');
          console.log('dskljfhsdlkjfkjl')

	$("#new_photo").ajaxForm({target: '.avatar_wrapper',
	     beforeSubmit:function(){

		console.log('ttest');
		$("#imageloadstatus").show();
		 $("#imageloadbutton").hide();
		 },
		success:function(){
	    console.log('test');
		 $("#imageloadstatus").hide();
		 $("#imageloadbutton").show();
		},
		error:function(){
		console.log('xtest');
		 $("#imageloadstatus").hide();
		$("#imageloadbutton").show();
		} }).submit();
});
