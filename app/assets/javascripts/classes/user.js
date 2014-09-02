/********************************************
Author: Kevin Ponce
Contact: kevinponce88@gmail.com
Dependencies: jquery-2.1.1.min
Description: this is a class to controll the user info
********************************************/
var User = function(){
	this.errors = {
		empty: "Parameter can't be empty.",
		invalid_email: 'Invalid Email'
	};

	this.invalid_usernames = ["user","users","post","get","posts","comments","signup","email","album","photo","gallery","test","beta","alpha","error"];
}

User.prototype.validateEmail = function(email){
	var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

User.prototype.errors = function(){
	var error = false;

	$('.row span').each(function(){
		if($(this).html() != ''){
			error = true;
		}
	});

	return error;
}

User.prototype.keyupErrors = function(my_settings){
	var _user = this;

	var settings = {
		target: '.signup input[tyepe=text], .login input[tyepe=text]',
		email:{
			name:'Email',
			error:'.email_error'
		},row:'.row',
		error_target:'span'
	};

	if(typeof my_settings === "object"){
		var settings = _user.merge(settings,my_settings);
	}

	$(document).on('keyup',settings.target,function(e){
		var _this = $(this);
		var name = _this.attr('name');
		var value = _this.val();


		if(name == settings.email.name){
			var emailResp = _this.closest(settings.row).find(settings.email.error);

			//checks if email is set and is a valid email
			if(value != '' && !_user.validateEmail(value)){
				emailResp.html(_user.errors.invalid_email);
			}else{
				//update email error message to nothing
				emailResp.html(_user.errors.empty);
			}
		}else{
			//handles basic error checking for geneir parameters
			var errorResp = _this.closest(settings.row).find(settings.error_target);

			//updates the error message
			if(value.length == 0){
				errorResp.html(_user.errors.empty);
			}else{
				errorResp.html('');
			}
		}
	});
}


User.prototype.emailChange = function(my_settings){
	var _user = this;

	var settings = {
		target: '#Email',
		row:'.row',
		error:'.email_error',
		url:'/user/email-exist'
	};

	if(typeof my_settings === "object"){
		var settings = _user.merge(settings,my_settings);
	}

	//checks if the email already exist in the database
	$(document).on('change',settings.target,function(e){
		var _this = $(this);
		var email = _this.val();
		var emailResp = _this.closest(settings.row).find(settings.error);

		//checks if email is set and is a valid email
		if(email != '' && user.validateEmail(email)){

			$.post(settings.url,{
				'authenticity_token': $('meta[name="csrf-token"]').attr('content'),
				email:email
			},function(check_email_resp){
				
				//checks if email has changed since request was sent
				if(email == _this.val()){
					emailResp.html(check_email_resp);
				}
			})
		}
	});
}

User.prototype.userChange = function(my_settings){
	var _user = this;

	var settings = {
		target: '#Username',
		row:'.row',
		error:'.username_error',
		url:'/user/username-exist'
	};

	if(typeof my_settings === "object"){
		var settings = _user.merge(settings,my_settings);
	}

	//checks if the username already exist in the database
	$(document).on('change',settings.target,function(e){
		var _this = $(this);
		var username = _this.val();
		var usernameResp = _this.closest(settings.row).find(settings.error);

		//checks if username is set
		if(username != ''){

			$.post(settings.url,{
				'authenticity_token': $('meta[name="csrf-token"]').attr('content'),
				username:username
			},function(check_username_resp){
				
				//checks if email has changed since request was sent
				if(username == _this.val()){
					usernameResp.html(check_username_resp);
				}
			})
		}
	});
}

User.prototype.submit = function(my_settings){
	var _user = this;

	var settings = {
		target: '.signup, .login',
		row:'.row',
		error:'span',
		redirect_url:'/',
		empty:[],
		message_target:''
	};

	if(typeof my_settings === "object"){
		var settings = _user.merge(settings,my_settings);
	}

	$(document).on('submit',settings.target,function(e){
		e.preventDefault();
		e.stopPropagation();

		var form = $(this);
		var singup_json = {};
		var params_valid = true;

		form.find('input[type=text],select,input[type=password]').each(function(){
			var name = $(this).attr('name');
			var value = $(this).val();

			if(settings['empty'].indexOf(name) == -1){
				if(value == ''){
					$(this).closest(settings.row).find(settings.error).html(user.errors.empty);
					params_valid = false;
				}

				singup_json[name] = value;
			}
		});

		singup_json['authenticity_token'] = $('meta[name="csrf-token"]').attr('content');

		if(params_valid){
			$.post(form.attr('action'),singup_json,function(resp){
				if(resp.error){
					for(var error in resp.errors){
						if (resp.errors.hasOwnProperty(error)) {
							if($('.'+error+'_error').html() == ''){
								$('.'+error+'_error').html(resp.errors[error]);
							}
						}
					}
				}else{
					window.location = settings.redirect_url;
				}

				if(settings.message_target != '' && typeof resp.message !== 'undefined' && $(settings.message_target).length > 0){
					$(settings.message_target).html(resp.message)
				}

			},'json');
		}

		return false;
	});
}




User.prototype.merge = function(options_1,optoins_2){
	if('undefined' !== typeof optoins_2){
	  for(var i in optoins_2){
		if('undefined' !== typeof optoins_2[i]){
		  options_1[i] = optoins_2[i];
		}
	  }
	}
	return options_1;
}